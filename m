MIME-Version: 1.0
References: <20180725202238.165314-1-salyzyn@android.com> <20180725210717.3b807191@vmware.local.home>
 <11437c3e-5131-7190-c496-7b51eb7fcc2a@android.com> <20180726153153.GA8327@kroah.com>
 <CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
 <20180726181558.25a5c3b8@gandalf.local.home> <753E9YR1QhdsPhsFoYuXCwfUzfyntDrc_A93hMUkktMi7lbh3KUZMcbfqKVWUfi15zYhuiDFant-ROa4QNV5shx74ff4hGngq2BOJDv-hq4=@protonmail.ch>
 <CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com>
 <20180727094730.3a448629@gandalf.local.home> <CAKwvOdmg4DSSwy9YBccYWzc+6ZU2yKSSFmfnj72wqbYDJU0gzw@mail.gmail.com>
 <20180727143141.4b53d554@gandalf.local.home> <CAMx4XWv3OazvURuN1XU2+5C5tNDzPuTniMn_T=XTA4P8_uwS_A@mail.gmail.com>
 <CAG48ez25zgjTQRux_rk1fn2DUVthtK31dRU9cxE+55pBGmYjXQ@mail.gmail.com>
In-Reply-To: <CAG48ez25zgjTQRux_rk1fn2DUVthtK31dRU9cxE+55pBGmYjXQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 27 Jul 2018 20:58:48 +0200
Message-ID: <CAG48ez1MdupASE1DMt0OWXv+rqZO-2GAbfDthEQcvNXrc2pTsQ@mail.gmail.com>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: salyzyn@google.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Nick Desaulniers <ndesaulniers@google.com>, Golden_Miller83@protonmail.ch, Greg KH <greg@kroah.com>, Kees Cook <keescook@google.com>, salyzyn@android.com, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, kernel-team@android.com, stable@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jeffrey Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

+cc jeffv

On Fri, Jul 27, 2018 at 8:47 PM Jann Horn <jannh@google.com> wrote:
>
> On Fri, Jul 27, 2018 at 8:41 PM Mark Salyzyn <salyzyn@google.com> wrote:
> >
> > Any system can chose to change the permissions of a sysfs node, default=
, DAC (and MAC) is just layers of multi-level security (or lack thereof). A=
s well intentioned as a default DAC is in the kernel, leaking kernel addres=
ses is still an attack surface that we want to close tightly.
> >
> > For instance on Android:
> >
> >      chmod 0755 /sys/kernel/debug/tracing
> >
> > is in the common init.rc file ...
> >
> > If DAC has been adjusted at runtime to permit access to the node, I wou=
ld think that if the caller does not have all the credentials/capabilities,=
 we do want the addresses to be abstracted by the kernel.
>
> If you adjust the access controls on debugfs to permit things that
> aren't possible upstream, you may have to add new access controls to
> ensure that that doesn't lead to security issues. And, in fact, you
> did:
>
> walleye:/ # ls -laZ /sys/kernel/debug
> total 0
> drwxr-xr-x 100 root root u:object_r:debugfs:s0             0 2018-07-27 1=
8:08 .
> drwxr-xr-x  19 root root u:object_r:sysfs:s0               0 1970-06-04 1=
0:30 ..
> [...]
> drwxr-xr-x   6 root root u:object_r:debugfs_tracing:s0     0
> 1970-01-01 01:00 tracing
> drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
> 1970-01-01 01:00 tsens
> drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
> 1970-01-01 01:00 tzdbg
> drwxr-xr-x   4 root root u:object_r:debugfs_ufs:s0         0
> 1970-01-01 01:00 ufshcd0
> drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
> 1970-01-01 01:00 usb
> drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
> 1970-01-01 01:00 usb-pdphy
> drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
> 1970-01-01 01:00 usb_diag
> drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
> 1970-01-01 01:00 vmem
> -r--r--r--   1 root root u:object_r:debugfs:s0             0
> 1970-01-01 01:00 wakeup_sources
> drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
> 2018-07-27 18:07 wcd_spi
> drwxr-xr-x   2 root root u:object_r:debugfs:s0             0
> 2018-07-27 18:07 wdsp0
> drwxr-xr-x   2 root root u:object_r:debugfs_wlan:s0        0
> 2018-07-27 18:07 wlan0
> drwxr-xr-x   3 root root u:object_r:debugfs:s0             0
> 2018-07-27 18:07 wlan_qdf
>
> Stuff in the debugfs mount is labeled as "debugfs", with a few
> exceptions. And the SELinux policy locks down access to debugfs:
>
> public/domain.te:neverallow { domain -init -vendor_init -system_server
> -dumpstate } debugfs:file no_rw_file_perms;

And yes, if you check from an ADB shell, you can still access the
mentioned file even on walleye:

walleye:/ $ ls -lZ /sys/kernel/debug/tracing/printk_formats
-r--r--r-- 1 root root u:object_r:debugfs_tracing:s0 0 1970-01-01
01:00 /sys/kernel/debug/tracing/printk_formats
walleye:/ $ cat /sys/kernel/debug/tracing/printk_formats
0xffffff9c60ba04de : "Rescheduling interrupts"
0xffffff9c60ba04f6 : "Function call interrupts"
0xffffff9c60ba050f : "CPU stop interrupts"
0xffffff9c60ba0523 : "Timer broadcast interrupts"
0xffffff9c60ba053e : "IRQ work interrupts"
0xffffff9c60ba0552 : "CPU wakeup interrupts"
0xffffff9c60ba0568 : "CPU backtrace"
0xffffff9c619a6600 : "rcu_sched"
0xffffff9c619a6a40 : "rcu_bh"
0xffffff9c619a6ef8 : "rcu_preempt"

But that's only because you're coming from "shell" context, and
"shell" context has explicitly been granted access to files labeled as
debugfs_tracing:

# systrace support - allow atrace to run
allow shell debugfs_tracing_debug:dir r_dir_perms;
allow shell debugfs_tracing:dir r_dir_perms;
allow shell debugfs_tracing:file rw_file_perms;
allow shell debugfs_trace_marker:file getattr;
allow shell atrace_exec:file rx_file_perms;

Normal apps can't access it, AFAICS.

If you think that the contents of this particular file should not be
exposed, because you think that even someone with ADB access or in
traceur_app context shouldn't be able to see those pointers, then you
may wish to make a change to how you're labeling tracefs files.
