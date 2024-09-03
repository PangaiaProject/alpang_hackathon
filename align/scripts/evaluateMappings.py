#!/usr/bin/env python3

import argparse as args
from math import floor
from os.path import basename
from sys import stderr
from Bio.SeqIO import parse
import re
from math import ulp

def readFasta(path):
    return [r for r in parse(open(path, 'r'), "fasta")]

#This function reads a mapping file in gaf format and returns a dictionary with mapping information per mapped sequence
def readMappingFile(file):
    mappings = {}

    for l in open(file, 'r'):
        elems = l.split('\t')
        readId = elems[0].split(' ')[0]
        
        if not readId in mappings:
            mappings[readId] = {"strand": elems[4], "path": elems[5], "start": int(elems[7]), "end": int(elems[8])}
        else:
            print("ERROR: Found a second mapping for sequence", elems[0], file=stderr)
            print("This was not expected to happen!", file=stderr)

    return mappings

#This function takes graph paths, graph sequences and mappings and calculates for each mapping the coordinates on a linear reference
def compMappingCoords(graphPaths, graphNodeSeqLens, mappingsPerHaplotype):
    mappingCoordsPerHaplotype = {}

    #Iterate over all haplotypes
    for h in mappingsPerHaplotype:
        mappingCoordsPerHaplotype[h] = {}
        
        for m in mappingsPerHaplotype[h]:
            currMapping = mappingsPerHaplotype[h][m]
            #We do not support the negative strand yet!
            strand = currMapping["strand"]
        
            #Testing
            # print("currMapping:", currMapping)
            
            if strand != '+':
                print(f"ERROR: Found strand {strand}. We do not support this yet!", file=stderr)
                continue
    
            #So far we only support mapping paths in which nodes are entered from the start (i.e., there are no '<' in the node sequence)
            mappingPath = currMapping["path"]
    
            # if mappingPath.find('<') >= 0:
            #     print("ERROR: Found '<' in mapping path. We do not support this yet!", file=stderr)
            #     continue
    
            #Testing
            # print("compMappingCoords: m:", m)
    
            graphPath = graphPaths[f"{h}#21#0"][:-1]

            #Testing
            # print("graphPath:", graphPath)
    
            #So far we do not support character '-' in graph paths
            if graphPath.find('-') >= 0:
                print("ERROR: Found '-' in graph path. We do not support this yet!", file=stderr)
                continue
            
            nodeSeq = re.split('>|<', mappingPath)[1:]
        
            #An index to keep track at which node in nodeSeq we are
            i = 0

            # startIsFound = False

            mappingStart = 0
    
            for v in graphPath.split("+,"):
                #Testing
                # print("i:", i)
                # print("len(nodeSeq):", len(nodeSeq))

                #We have not yet found the beginning of the mapping
                if v != nodeSeq[i]:# and not startIsFound:
                    mappingStart += graphNodeSeqLens[v]
                    i += 1

                    if i == len(nodeSeq):
                        break
                #We have just found the beginning of the mapping
                else:#if not startIsFound:
                    break

                #     startIsFound = True
    
                #     mappingEnd = mappingStart
                #     mappingStart += currMapping["start"]
    
                #     #Check if first node in the path is also the last
                #     if nodeSeq[i] == nodeSeq[-1]:
                #         mappingEnd += currMapping["end"] - 1
                #         break
                #     else:
                #         #Testing
                #         print("Increase i")

                #         i += 1
                # #We have not yet found the last mapped node
                # elif v != nodeSeq[-1]:
                #     i += 1
                # #We have found the last mapped node
                # else:
                #     mappingEnd += currMapping["end"] - 1
                #     break
    
            if m in mappingCoordsPerHaplotype[h]:
                print("WARNING: Found second mapping for read. Old mapping is overwritten!", file=stderr)

            #Testing
            # print(f"compMappingCoords: mappingStart: {mappingStart} mappingEnd: {mappingEnd}")
            # exit(0)

            pathLen = sum([graphNodeSeqLens[v] for v in graphNodeSeqLens])
            
            #Check if mapping path and haplotype path share any node
            if mappingStart == pathLen:
                mappingCoordsPerHaplotype[h][m] = (pathLen + 1, pathLen + 1)
            else:
                mappingCoordsPerHaplotype[h][m] = (mappingStart, mappingStart + currMapping["end"] - 1)

    return mappingCoordsPerHaplotype

#This script evaluates the quality of input mappings and returns the result
if __name__ == '__main__':
    #Setting up the argument parser
    parser = args.ArgumentParser(description="This script evaluates the quality of input mappings and returns the result.")
    parser.add_argument('-o', metavar='minOverlapRatio', type=float, required=True, help="Minimal overlap ration for 'correct mapping'")
    parser.add_argument('-m', metavar='mappings', type=str, required=True, nargs='+', help="Graph mapping files in GAF format")
    parser.add_argument('-g', metavar='tempGraph', type=args.FileType('r'), required=True, help="Template graph used for mapping")
    parser.add_argument('-r', metavar='reads', type=str, required=True, nargs='+', help="Mapped reads sequence files")
    arguments = parser.parse_args()
    #Read node sequences and paths from the graph
    graphNodeSeqLens = {}
    graphPaths = {}
    
    for l in arguments.g:
        if l.startswith("S"):
            elems = l.split('\t')
            graphNodeSeqLens[elems[1]] = len(elems[2].rstrip())
        if l.startswith("P"):
            elems = l.split('\t')
            graphPaths[elems[1]] = elems[2]
            
    #Read all mapping files
    mappingsPerHaplotype = {}

    for f in arguments.m:
        #We assume mappings files are named according to the scheme <Haplotype>.*gaf, where "<Haplotype>" is the name of the haplotype
        mappingsPerHaplotype[basename(f).split('.')[0]] = readMappingFile(f)
        
    #Calculate linear coordinates for all mappings        
    mappingCoordsPerHaplotype = compMappingCoords(graphPaths, graphNodeSeqLens, mappingsPerHaplotype)
    mappingOutcome = {}
    
    for h in mappingCoordsPerHaplotype:
        #Parse read coordinates and initialize mappingOutcome dictionary
        readCoords = {}
        mappingOutcome[h] = {}

        #Find the read file corresponding to the current haplotype
        for i in range(len(arguments.r)):
            #We assume the haplotype name appears inside the read file's name
            if arguments.r[i].find(h) > -1:
                readFileName = arguments.r[i]
                break
                
        #Parse read file corresponding to current haplotype
        for r in readFasta(readFileName):
            start, end = r.description.split(':')[2].split(' ')[0].split('-')
            readCoords[r.id] = (int(start), int(end))
        
        for m in mappingCoordsPerHaplotype[h]:
            readLen = readCoords[m][1] - readCoords[m][0]
            mappingLen = mappingCoordsPerHaplotype[h][m][1] - mappingCoordsPerHaplotype[h][m][0]
            
            if mappingCoordsPerHaplotype[h][m][0] <= readCoords[m][0] and readCoords[m][1] <= mappingCoordsPerHaplotype[h][m][1]:
                isCorrect = readCoords[m][1] - readCoords[m][0] >= floor(arguments.o * max(readLen, mappingLen))
            elif readCoords[m][0] <= mappingCoordsPerHaplotype[h][m][0] and mappingCoordsPerHaplotype[h][m][1] <= readCoords[m][1]:
                isCorrect = mappingCoordsPerHaplotype[h][m][1] - mappingCoordsPerHaplotype[h][m][0] >= floor(arguments.o * max(readLen, mappingLen))
            elif readCoords[m][0] <= mappingCoordsPerHaplotype[h][m][0] and readCoords[m][1] <= mappingCoordsPerHaplotype[h][m][1]:
                isCorrect = max(0, readCoords[m][1] - mappingCoordsPerHaplotype[h][m][0]) >= floor(arguments.o * max(readLen, mappingLen))
            else:
                isCorrect = max(0, mappingCoordsPerHaplotype[h][m][1] - readCoords[m][0]) >= floor(arguments.o * max(readLen, mappingLen))
    
            mappingOutcome[h][m] = isCorrect

    tcounter = 0
    tncounter = ulp(0.0)

    for h in mappingOutcome:
        for m in mappingOutcome[h]:
            if mappingOutcome[h][m]:
                tcounter += 1
            else:
                tncounter += 1
    
    print(f"Number of correctly mapped reads: {tcounter} ({int(float(tcounter)/(tcounter+tncounter) * 100)}%)")
    