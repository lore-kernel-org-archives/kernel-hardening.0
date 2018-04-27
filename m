MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180427134936.GA31171@kroah.com>
References: <20180427123547.15727-1-tmricht@linux.ibm.com> <20180427134936.GA31171@kroah.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 27 Apr 2018 07:58:35 -0700
Message-ID: <CAGXu5j+LK8-g9bg+RNn+-v1LpRC32sTCAUNZr1v0HXquiG9fQw@mail.gmail.com>
Subject: Re: [PATCH v2] inode: debugfs_create_dir uses mode permission from parent
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, brueckner@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 27, 2018 at 6:49 AM, Greg KH <gregkh@linuxfoundation.org> wrote=
:
> I'm going to add Kees and the kernel-hardning list here, as I'd like
> their opinions for the patch below.
>
> Kees, do you have any problems with this patch?  I know you worked on
> making debugfs more "secure" from non-root users, this should still keep
> the intial mount permissions all fine, right?  Anything I'm not
> considering here?

This appears correct to me. I'd like to see some stronger rationale
for why this is needed, just so I have a "design" to compare the
implementation against. :)

Normally, the top-level directory permissions should block all the
subdirectories too. The only time I think of this being needed is if
someone is explicitly bind-mounting a subdirectory to another location
(e.g. Chrome OS does this for the i915 subdirectory). In that case,
I'd expect them to tweak permissions too. Thomas, what's your
use-case?

-Kees

>
> thanks,
>
> greg k-h
>
> On Fri, Apr 27, 2018 at 02:35:47PM +0200, Thomas Richter wrote:
>> Currently function debugfs_create_dir() creates a new
>> directory in the debugfs (usually mounted /sys/kernel/debug)
>> with permission rwxr-xr-x. This is hard coded.
>>
>> Change this to use the parent directory permission.
>>
>> Output before the patch:
>> root@s8360047 ~]# tree -dp -L 1 /sys/kernel/debug/
>> /sys/kernel/debug/
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  bdi
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  block
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  dasd
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  device_component
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  extfrag
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  hid
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  kprobes
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  kvm
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  memblock
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  pm_qos
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  qdio
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  s390
>> =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  s390dbf
>> =E2=94=94=E2=94=80=E2=94=80 [drwx------]  tracing
>>
>> 14 directories
>> [root@s8360047 linux]#
>>
>> Output after the patch:
>> [root@s8360047 ~]# tree -dp -L 1 /sys/kernel/debug/
>> sys/kernel/debug/
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  bdi
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  block
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  dasd
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  device_component
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  extfrag
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  hid
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  kprobes
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  kvm
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  memblock
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  pm_qos
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  qdio
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  s390
>> =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  s390dbf
>> =E2=94=94=E2=94=80=E2=94=80 [drwx------]  tracing
>>
>> 14 directories
>> [root@s8360047 linux]#
>>
>> Here is the full diff output done with:
>> [root@s8360047 ~]# diff -u treefull.before treefull.after |
>>       sed 's-^- # -' > treefull.diff
>>  # --- treefull.before        2018-04-27 13:22:04.532824564 +0200
>>  # +++ treefull.after 2018-04-27 13:24:12.106182062 +0200
>>  # @@ -1,55 +1,55 @@
>>  #  /sys/kernel/debug/
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  bdi
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:0
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:1
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:10
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:11
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:12
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:13
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:14
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:15
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:2
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:3
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:4
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:5
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:6
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:7
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:8
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  1:9
>>  # -=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwxr-xr-x]  94:0
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  block
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  dasd
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  0.0.e18a
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  dasda
>>  # -=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwxr-xr-x]  global
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  device_component
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  extfrag
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  hid
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  kprobes
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  kvm
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  memblock
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  pm_qos
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  qdio
>>  # -=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwxr-xr-x]  0.0.f5f2
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  s390
>>  # -=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwxr-xr-x]  stsi
>>  # -=E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  s390dbf
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  0.0.e18a
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  cio_crw
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  cio_msg
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  cio_trace
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  dasd
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  kvm-trace
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  lgr
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  qdio_0.0.f5f2
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  qdio_error
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  qdio_setup
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  qeth_card_0.0.=
f5f0
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  qeth_control
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  qeth_msg
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  qeth_setup
>>  # -=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  vmcp
>>  # -=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwxr-xr-x]  vmur
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  bdi
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:0
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:1
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:10
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:11
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:12
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:13
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:14
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:15
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:2
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:3
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:4
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:5
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:6
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:7
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:8
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  1:9
>>  # +=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwx------]  94:0
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  block
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  dasd
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  0.0.e18a
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  dasda
>>  # +=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwx------]  global
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  device_component
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  extfrag
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  hid
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  kprobes
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  kvm
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  memblock
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  pm_qos
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  qdio
>>  # +=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwx------]  0.0.f5f2
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  s390
>>  # +=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwx------]  stsi
>>  # +=E2=94=9C=E2=94=80=E2=94=80 [drwx------]  s390dbf
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  0.0.e18a
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  cio_crw
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  cio_msg
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  cio_trace
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  dasd
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  kvm-trace
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  lgr
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  qdio_0.0.f5f2
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  qdio_error
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  qdio_setup
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  qeth_card_0.0.=
f5f0
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  qeth_control
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  qeth_msg
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  qeth_setup
>>  # +=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwx------]  vmcp
>>  # +=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 [drwx------]  vmur
>>  #  =E2=94=94=E2=94=80=E2=94=80 [drwx------]  tracing
>>  #      =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  events
>>  #      =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 [drwxr-xr-x]  alarmtimer
>>
>> Fixes: edac65eaf8d5c ("debugfs: take mode-dependent parts of debugfs_get=
_inode() into callers")
>> Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  fs/debugfs/inode.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
>> index 13b0135..a913b12 100644
>> --- a/fs/debugfs/inode.c
>> +++ b/fs/debugfs/inode.c
>> @@ -512,7 +512,9 @@ struct dentry *debugfs_create_dir(const char *name, =
struct dentry *parent)
>>       if (unlikely(!inode))
>>               return failed_creating(dentry);
>>
>> -     inode->i_mode =3D S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
>> +     if (!parent)
>> +             parent =3D debugfs_mount->mnt_root;
>> +     inode->i_mode =3D S_IFDIR | ((d_inode(parent)->i_mode & 0770));
>>       inode->i_op =3D &simple_dir_inode_operations;
>>       inode->i_fop =3D &simple_dir_operations;
>>
>> --
>> 2.9.3



--=20
Kees Cook
Pixel Security
