# Docker image for Software in the DFG SPP Computeralgebra

This repository contains the Dockerfile for a Docker image
containing some of the software created in the DFG SPP Computeralgebra.
The image is availible at https://registry.hub.docker.com/u/sebasguts/sppdocker/

At the moment, the image contains the following software:

* Singular (with flint, version of the day)
* Polymake (latest snapshot)
* Normaliz (3.0)
* 4ti2 (independent Polymake)
* nemo
* GAP together with:
  - homalg (deposited packages)
  - PolymakeInterface
  and the newer develepments in GAP
  - homalg (undeposited packages)
  - CAP
  - SingularInterface
  - NormalizInterface
  - 4ti2gap

To start a Docker container from the image, you need a new version of
docker installed on your computer (see https://docs.docker.com/ )
Then you can start a container with
```
docker run -it sebasguts/sppdocker
```
Once this is done, you are presented with a shell, where
you can execute the CAS listed above as you are used to.

# Examples

## Singular
```
docker run -it sebasguts/sppdocker
spp@331a7b40b170:~$ Singular
                     SINGULAR                                 /  Development
 A Computer Algebra System for Polynomial Computations       /   version 4.0.2
                                                           0<
 by: W. Decker, G.-M. Greuel, G. Pfister, H. Schoenemann     \   Feb 2015
FB Mathematik der Universitaet, D-67653 Kaiserslautern        \
>
```

## Polymake
```
spp@331a7b40b170:~$ polymake
Welcome to polymake version 2.14
Copyright (c) 1997-2015
Ewgenij Gawrilow, Michael Joswig (TU Berlin)
http://www.polymake.org

This is free software licensed under GPL; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Press F1 or enter 'help;' for basic instructions.

Application polytope currently uses following third-party software packages:
4ti2, bliss, cdd, libnormaliz, lrs, normaliz2, permlib, singular, sketch, sympol, threejs, tikz, tosimplex
For more details:  show_credits;

polytope >
```

## GAP and NormalizInterface
```
spp@331a7b40b170:~$ gapL
 *********   GAP, Version 4.7.8 of 09-Jun-2015 (free software, GPL)
 *  GAP  *   http://www.gap-system.org
 *********   Architecture: x86_64-unknown-linux-gnu-gcc-default64
 Libs used:  gmp, readline
 Loaded workspace: /opt/gap4r7/bin/wsgap4
 Components: trans 1.0, prim 2.1, small* 1.0, id* 1.0
 Packages:   AClib 1.2, Alnuth 3.0.0, AtlasRep 1.5.0, AutPGrp 1.6,
             Browse 1.8.6, CRISP 1.3.8, Cryst 4.1.12, CrystCat 1.1.6,
             CTblLib 1.2.2, EDIM 1.3.2, FactInt 1.5.3, FGA 1.2.0,
             GAPDoc 1.5.1, IO 4.4.4, IRREDSOL 1.2.4, LAGUNA 3.7.0,
             Polenta 1.3.2, Polycyclic 2.11, RadiRoot 2.7,
             ResClasses 3.4.0, Sophus 1.23, SpinSym 1.5, TomLib 1.2.5
 Try '?help' for help. See also  '?copyright' and  '?authors'
gap> LoadPackage( "NormalizInterface" );
----------------------------------------------------------------------
Loading  NormalizInterface 0.3 (GAP wrapper for normaliz)
by Sebastian Gutsche (http://wwwb.math.rwth-aachen.de/~gutsche/),
   Max Horn (http://www.quendi.de/math), and
   Christof S�ger (http://www.math.uos.de/normaliz).
Homepage: https://github.com/fingolfin/NormalizInterface
----------------------------------------------------------------------
true
gap> C := NmzCone(["integral_closure",[[2,1],[1,3]]]);
<a Normaliz cone with long int coefficients>
gap> NmzConeProperty(C,"HilbertBasis");
[ [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 2, 1 ] ]
```

## Normaliz
```
spp@331a7b40b170:~$ normaliz 3x3magic.in 
spp@331a7b40b170:~$ cat 3x3magic.out
5 Hilbert basis elements
5 Hilbert basis elements of degree 1
4 extreme rays
4 support hyperplanes

embedding dimension = 9
rank = 3
external index = 1

size of triangulation   = 2
resulting sum of |det|s = 4

grading:
1 1 1 0 0 0 0 0 0 
with denominator = 3

degrees of extreme rays:
1: 4

Hilbert basis elements are of degree 1

multiplicity = 4

Hilbert series:
1 2 1 
denominator with 3 factors:
1: 3

degree of Hilbert Series as rational function = -1

Hilbert polynomial:
1 2 2 
with common denominator = 1

rank of class group = 1
finite cyclic summands:
2: 2  

***********************************************************************

5 Hilbert basis elements of degree 1:
 0 2 1 2 1 0 1 0 2
 1 0 2 2 1 0 0 2 1
 1 1 1 1 1 1 1 1 1
 1 2 0 0 1 2 2 0 1
 2 0 1 0 1 2 1 2 0

0 further Hilbert basis elements of higher degree:

4 extreme rays:
 0 2 1 2 1 0 1 0 2
 1 0 2 2 1 0 0 2 1
 1 2 0 0 1 2 2 0 1
 2 0 1 0 1 2 1 2 0

4 support hyperplanes:
 -2 -1 0 0  4 0 0 0 0
  0 -1 0 0  2 0 0 0 0
  0  1 0 0  0 0 0 0 0
  2  1 0 0 -2 0 0 0 0

6 equations:
 1 0 0 0 0  1 -2 -1  1
 0 1 0 0 0  1 -2  0  0
 0 0 1 0 0  1 -1 -1  0
 0 0 0 1 0 -1  2  0 -2
 0 0 0 0 1 -1  1  0 -1
 0 0 0 0 0  3 -4 -1  2

3 basis elements of lattice:
 1 0 -1 -2 0  2  1  0 -1
 0 1 -1 -1 0  1  1 -1  0
 0 0  3  4 1 -2 -1  2  2
```
