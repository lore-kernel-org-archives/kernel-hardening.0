Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 19 Jan 2016 16:49:23 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Message-ID: <20160119154923.GA5130@chrystal.uk.oracle.com>
References: <20160119112812.GA10818@mwanda>
 <20160119124917.6058019b@pc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160119124917.6058019b@pc1>
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com
Cc: Vegard Nossum <vegard.nossum@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 12:49:17PM +0100, Hanno Böck wrote:
> On Tue, 19 Jan 2016 14:28:12 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > There was only a coupls CVEs that looks like they came from a
> > filesystem fuzzer where you create a corrupt filesystems and then try
> > use them.
> 
> I tried that, but it didn't lead to any results in the kernel [1].
> What I did:
> * Use filesystem checking tools (fsck) and fuzz them with afl
> * Use the queue created by afl and try to mount these with a
>   kasan-enabled kernel
> 
> My conclusion was that the filesystem code in the kernel is relatively
> robust (at least robust enough for this trivial fuzzing).
> But it led to a number of bugs discovered in filesystem fsck tools.
> 

As an experimental toy project, we've managed to implement the glue to have
AFL run on the kernel code, using either a patched afl-as wrapper or a
slightly modified GCC extension written by Dmitry Vyukov for syzkaller
(-fsanitize-coverage=trace-pc), and our conclusion is quite different.

In the month Vegard Nossum has been using it, he reported at least a dozen
problems at mount or readdir time:

btrfs:
 https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg48448.html
 https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg48976.html
 https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg49011.html

ext4:
 http://marc.info/?l=linux-ext4&m=144898824424465&w=2
 https://lkml.org/lkml/2015/12/13/187

hfs:
 http://marc.info/?l=linux-fsdevel&m=144900215929323&w=2

isofs:
 https://marc.info/?l=linux-kernel&m=144933509518680&w=2

udf:
 https://lkml.org/lkml/2015/12/10/438
 https://lkml.org/lkml/2015/12/11/526

vfat:
 https://lkml.org/lkml/2015/11/13/782
 https://lkml.org/lkml/2015/11/23/36

xfs:
 https://marc.info/?l=linux-xfs&m=144904267207656&w=2

It should be noted that most of these problems were found relatively
quickly and without changing much the filesystem code, checksums weren't
disabled for example a part for superblock checksum in btrfs.  And that was
mostly fuzzing the mount/readdir syscalls so a lot more can probably be
found there.

Thanks,
Quentin
