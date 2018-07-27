MIME-Version: 1.0
References: <20180725202238.165314-1-salyzyn@android.com> <20180725210717.3b807191@vmware.local.home>
 <11437c3e-5131-7190-c496-7b51eb7fcc2a@android.com> <20180726153153.GA8327@kroah.com>
 <CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
 <20180726181558.25a5c3b8@gandalf.local.home> <753E9YR1QhdsPhsFoYuXCwfUzfyntDrc_A93hMUkktMi7lbh3KUZMcbfqKVWUfi15zYhuiDFant-ROa4QNV5shx74ff4hGngq2BOJDv-hq4=@protonmail.ch>
 <CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com>
 <20180727094730.3a448629@gandalf.local.home> <CAKwvOdmg4DSSwy9YBccYWzc+6ZU2yKSSFmfnj72wqbYDJU0gzw@mail.gmail.com>
 <20180727143141.4b53d554@gandalf.local.home> <CAMx4XWv3OazvURuN1XU2+5C5tNDzPuTniMn_T=XTA4P8_uwS_A@mail.gmail.com>
In-Reply-To: <CAMx4XWv3OazvURuN1XU2+5C5tNDzPuTniMn_T=XTA4P8_uwS_A@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 27 Jul 2018 20:47:27 +0200
Message-ID: <CAG48ez25zgjTQRux_rk1fn2DUVthtK31dRU9cxE+55pBGmYjXQ@mail.gmail.com>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: salyzyn@google.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Nick Desaulniers <ndesaulniers@google.com>, Golden_Miller83@protonmail.ch, Greg KH <greg@kroah.com>, Kees Cook <keescook@google.com>, salyzyn@android.com, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, kernel-team@android.com, stable@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 27, 2018 at 8:41 PM Mark Salyzyn <salyzyn@google.com> wrote:
>
> Any system can chose to change the permissions of a sysfs node, default, =
DAC (and MAC) is just layers of multi-level security (or lack thereof). As =
well intentioned as a default DAC is in the kernel, leaking kernel addresse=
s is still an attack surface that we want to close tightly.
>
> For instance on Android:
>
>      chmod 0755 /sys/kernel/debug/tracing
>
> is in the common init.rc file ...
>
> If DAC has been adjusted at runtime to permit access to the node, I would=
 think that if the caller does not have all the credentials/capabilities, w=
e do want the addresses to be abstracted by the kernel.

If you adjust the access controls on debugfs to permit things that
aren't possible upstream, you may have to add new access controls to
ensure that that doesn't lead to security issues. And, in fact, you
did:

walleye:/ # ls -laZ /sys/kernel/debug
total 0
drwxr-xr-x 100 root root u:object_r:debugfs:s0             0 2018-07-27 18:=
08 .
drwxr-xr-x  19 root root u:object_r:sysfs:s0               0 1970-06-04 10:=
30 ..
[...]
drwxr-xr-x   6 root root u:object_r:debugfs_tracing:s0     0
1970-01-01 01:00 tracing
drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
1970-01-01 01:00 tsens
drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
1970-01-01 01:00 tzdbg
drwxr-xr-x   4 root root u:object_r:debugfs_ufs:s0         0
1970-01-01 01:00 ufshcd0
drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
1970-01-01 01:00 usb
drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
1970-01-01 01:00 usb-pdphy
drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
1970-01-01 01:00 usb_diag
drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
1970-01-01 01:00 vmem
-r--r--r--   1 root root u:object_r:debugfs:s0             0
1970-01-01 01:00 wakeup_sources
drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
2018-07-27 18:07 wcd_spi
drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
2018-07-27 18:07 wdsp0
drwxr-xr-x   2 root root u:object_r:debugfs_wlan:s0        0
2018-07-27 18:07 wlan0
drwxr-xr-x   3 root root u:object_r:debugfs:s0             0
2018-07-27 18:07 wlan_qdf

Stuff in the debugfs mount is labeled as "debugfs", with a few
exceptions. And the SELinux policy locks down access to debugfs:

public/domain.te:neverallow { domain -init -vendor_init -system_server
-dumpstate } debugfs:file no_rw_file_perms;

> On Fri, Jul 27, 2018 at 11:31 AM, Steven Rostedt <rostedt@goodmis.org> wr=
ote:
>>
>> On Fri, 27 Jul 2018 11:13:51 -0700
>> Nick Desaulniers <ndesaulniers@google.com> wrote:
>>
>> > I found the internal bug report (reported Jan '17, you'll have to
>> > forgive me if my memory of the issue is hazy, or if the fix used at
>> > the time wasn't perfect), which was reported against the Nexus 6.
>> > >From the report, it was possible to `cat
>> > /sys/kernel/debug/tracing/printk_formats` without being root, which I
>> > can't do on my workstations much more modern kernel (Nexus 6 was
>> > 3.10).  So I guess the question is what governs access to files below
>> > /sys/kernel/debug, and why was it missing from those kernels?  I
>> > assume some check was added, but either not backported to 3.10 stable
>> > (or more likely not pulled in to Nexus 6's kernel through stable;
>> > Android is now in a much better place for that kind of issue).
>>
>> As of commit 82aceae4f0d4 ("debugfs: more tightly restrict default
>> mount mode") /sys/kernel/debug has been default mounted as 0700 (root
>> only). But that was introduced in 3.7. Not sure why your 3.10 kernel
>> didn't have that. Perhaps there's another commit that fixed
>> permissions not being inherited?
>>
>> -- Steve
>>
>> --
>> You received this message because you are subscribed to the Google Group=
s "kernel-team" group.
>> To unsubscribe from this group and stop receiving emails from it, send a=
n email to kernel-team+unsubscribe@android.com.
>>
>
