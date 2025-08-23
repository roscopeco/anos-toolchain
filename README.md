## Anos toolchain 🛠️

> [!NOTE]
> This is still evolving as the design of Anos is fleshed
> out and evolved. Many of the newlib syscalls are simply
> stubbed here, which has the effect of making many other
> things not work or work incorrectly.
>
> As the syscall interface in Anos itself is settled, this
> will settle along with it.

### What is this?

This is a custom Binutils / GCC toolchain for 
[Anos](https://github.com/roscopeco/anos), with libc supplied
by Newlib with a custom Anos-specific `libgloss`.

Currently, `x86_64` is supported well enough to build base
system binaries as hosted code. RISC-V support is still a 
work-in-progress. 

If you want to build Anos, you will need to build this
toolchain first! See instructions 👇

### Building

#### Prerequisites

You'll need some packages installed. Install from your package manager of
choice if you don't already have them:

* libmpc-dev
* libmpfr-dev
* libgmp-dev
* texinfo
* bison
* flex

If you're on an M-series Mac and install with homebrew:

```shell
brew install libmpc mpfr gmp
```

> [!NOTE]
> You _probably_ don't need to install texinfo, bison and flex
> but they are available - though keg only so you may need to link
> them by hand. Homebrew will show you the commands you need.

If you haven't already, you'll need to ensure the homebrew paths
are included in `CPATH` and `LIBRARY_PATH` too. This shouldn't
be needed on Intel macs.

```shell
export CPATH=$HOMEBREW_PREFIX/include:$CPATH
```

```shell
export LIBRARY_PATH=$HOMEBREW_PREFIX/lib:$LIBRARY_PATH
```

#### Fetch submodules

```shell
git submodule init
```

```shell
git submodule update
```

#### Create unified source directory

```shell
sh linkem.sh
```

#### Make a build directory

```shell
mkdir build-all
```

```shell
cd build-all
```

#### Configure

##### x86_64

```shell
../srcw/configure --target=x86_64-elf-anos --enable-languages=c,c++ --with-newlib --prefix="$HOME/opt/cross-anos" --disable-debug --disable-dependency-tracking --disable-silent-rules --disable-nls --with-debug-prefix-map="../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../../srcw='$(readlink -f ..)/srcw'"
```

> [!WARNING]
> If you're on macOS there's a reasonable chance you'll hit errors when building with Apple clang. You'll 
> save yourself some pain if you just brew install gcc (and build dependencies) and use that to build the
> toolchain. 
>
> You'll know you've hit this if you see errors coming from `stdio.h` and other standard includes early
> in the build. At time of writing, GCC needs some things updating (e.g. `zlib`) which is a painful process,
> so run this instead:

```shell
brew install gcc@14 gmp mpfr libmpc

CC=$(which gcc-14) ../srcw/configure --target=x86_64-elf-anos --enable-languages=c,c++ --with-newlib --prefix="$HOME/opt/cross-anos" --disable-debug --disable-dependency-tracking --disable-silent-rules --disable-nls --with-debug-prefix-map="../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../../srcw='$(readlink -f ..)/srcw'" --with-gmp=$(brew --prefix gmp) --with-mpfr=$(brew --prefix mpfr) --with-mpc=$(brew --prefix libmpc)$
```

##### riscv64

To build for riscv64, simply change the `--target` option to `riscv64-elf-anos`, i.e.:

```shell
../srcw/configure --target=riscv64-elf-anos --enable-languages=c,c++ --with-newlib --prefix="$HOME/opt/cross-anos" --disable-debug --disable-dependency-tracking --disable-silent-rules --disable-nls --with-debug-prefix-map="../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../../srcw='$(readlink -f ..)/srcw'"
```

> [!WARNING]
> The same caveat as above applies when building on macOS. To use GCC instead:

```shell
CC=$(which gcc-14) ../srcw/configure --target=riscv64-elf-anos --enable-languages=c,c++ --with-newlib --prefix="$HOME/opt/cross-anos" --disable-debug --disable-dependency-tracking --disable-silent-rules --disable-nls --with-debug-prefix-map="../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../../srcw='$(readlink -f ..)/srcw'" --with-gmp=$(brew prefix gmp) --with-mpfr=$(brew --prefix mpfr) --with-mpc=$(brew --prefix libmpc)$
```

#### Build (takes a while)

```shell
make -j9 all-build all-binutils all-gas all-ld all-gcc all-target-libgcc all-target-newlib all-target-libgloss
```

#### Install

```shell
make install-binutils install-gas install-ld install-gcc install-target-libgcc install-target-newlib install-target-libgloss
```

#### Test

```shell
cd ..
```

```shell
PATH="$HOME/opt/cross-anos/bin:$PATH" x86_64-elf-anos-gcc -o test.elf test.c
```
