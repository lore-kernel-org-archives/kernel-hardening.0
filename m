MIME-Version: 1.0
References: <20180703201931.79b546f8@computer.lan>
In-Reply-To: <20180703201931.79b546f8@computer.lan>
From: Jann Horn <jannh@google.com>
Date: Tue, 3 Jul 2018 21:47:34 +0200
Message-ID: <CAG48ez0efGF2TQ4Di9FnTJq091z7SpWBcB+oj1gG05AKiZ0U2g@mail.gmail.com>
Subject: Re: Patch for SymlinksIfOwnerMatches
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: hanno@hboeck.de, Al Viro <viro@zeniv.linux.org.uk>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 3, 2018 at 8:29 PM Hanno B=C3=B6ck <hanno@hboeck.de> wrote:
>
> Hi,
>
> There's a nasty problem in many webserver configurations on multiuser
> systems, I've blogged about it a while ago [1]. With a symlink it's
> often possible to read out configuration files of other users. This was
> famously used in the freedom hosting II hack [2].
>
> grsecurity had a workaround for this: By not allowing file operations
> to follow symlinks if the owner of the link and the target don't match
> it can block this kind of attack.
>
> I saw a need to keep this feature alive in a post-grsecurity world, so
> a while ago I extracted it from the grsecurity patch. I've now made
> that public:
> https://github.com/hannob/symlinkown
>
> I'm not sure about upstreaming, I think it's a worthy feature, but it
> might need some work in polishing it. But for now I'll just share it
> and I will hopefully be able to keep the patch working for future
> kernels.
>
> [1]
> https://blog.hboeck.de/archives/873-The-tricky-security-issue-with-Follow=
SymLinks-and-Apache.html
> [2]
> https://securityaffairs.co/wordpress/55990/deep-web/freedom-hosting-ii-ha=
ck.html

+cc Al Viro because this is related to AT_BENEATH and other path walk stuff

Hmm. Actually, I wonder whether the kernel is a good place to handle
this at all.

As you note, Apache already has the option SymLinksIfOwnerMatch, which
means that it already has to do a component-wise path walk in
userspace (because AT_BENEATH hasn't landed yet). Here's what "strace"
reports when Apache with that option is following a symlink:

root@vm:~# strace -f -p5559 -p5560 -e
trace=3D'!accept4,futex,epoll_wait,epoll_ctl,read,write,fcntl,getsockname'
strace: Process 5559 attached with 27 threads
strace: Process 5560 attached with 27 threads
[pid  5613] mmap(NULL, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D 0x7f584a463000
[pid  5613] mmap(NULL, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D 0x7f584a461000
[pid  5613] mmap(NULL, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D 0x7f584a45f000
[pid  5613] stat("/var/www/html/foo/bar/link/subdir/hello",
{st_mode=3DS_IFREG|0644, st_size=3D12, ...}) =3D 0
[pid  5613] lstat("/var", {st_mode=3DS_IFDIR|0755, st_size=3D4096, ...}) =
=3D 0
[pid  5613] lstat("/var/www", {st_mode=3DS_IFDIR|0755, st_size=3D4096, ...}=
) =3D 0
[pid  5613] lstat("/var/www/html", {st_mode=3DS_IFDIR|0755,
st_size=3D4096, ...}) =3D 0
[pid  5613] lstat("/var/www/html/foo", {st_mode=3DS_IFDIR|0755,
st_size=3D4096, ...}) =3D 0
[pid  5613] lstat("/var/www/html/foo/bar", {st_mode=3DS_IFDIR|0755,
st_size=3D4096, ...}) =3D 0
[pid  5613] lstat("/var/www/html/foo/bar/link", {st_mode=3DS_IFLNK|0777,
st_size=3D17, ...}) =3D 0
[pid  5613] stat("/var/www/html/foo/bar/link", {st_mode=3DS_IFDIR|0755,
st_size=3D4096, ...}) =3D 0
[pid  5613] lstat("/var/www/html/foo/bar/link/subdir",
{st_mode=3DS_IFDIR|0755, st_size=3D4096, ...}) =3D 0
[pid  5613] lstat("/var/www/html/foo/bar/link/subdir/hello",
{st_mode=3DS_IFREG|0644, st_size=3D12, ...}) =3D 0
[pid  5613] mmap(NULL, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =3D 0x7f584a45d000
[pid  5613] openat(AT_FDCWD,
"/var/www/html/foo/bar/link/subdir/hello", O_RDONLY|O_CLOEXEC) =3D 13

If, instead of using lstat() and open(), this code used fstatat() and
openat(), you could deal with symlink races in userspace. In theory,
for very long paths, this might also be faster; the current code has
to follow O(n^2) path elements. At that point, the only small
remaining problem would be that you could determine whether a given
path exists by using a symlink that points into that path and
traverses back out with a sequence of ".."; if you want to also deal
with that, you'd have to also do symlink resolution in userspace.
