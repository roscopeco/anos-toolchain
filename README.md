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

Currently, only `x86_64` is supported, but eventually
we'll support riscv as well.

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

```shell
../srcw/configure --target=x86_64-elf-anos --enable-languages=c,c++ --with-newlib --prefix="$HOME/opt/cross-anos" --disable-debug --disable-dependency-tracking --disable-silent-rules --disable-nls --with-debug-prefix-map="../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../srcw='$(readlink -f ..)/srcw'" --with-debug-prefix-map="../../../../../srcw='$(readlink -f ..)/srcw'"
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
