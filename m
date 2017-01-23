MIME-Version: 1.0
In-Reply-To: <CAEiveUe87HZK45Vs1VsTKcPMpLAav53JZb9_5-3Bc--FCGDf3A@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
 <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com>
 <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
 <CAEiveUdOdMr=gJZsi=Fx-CNeC8jkyi8XxC+qSG-LXWj3o2t=_A@mail.gmail.com>
 <CALCETrX_K7XdyCRo1RSLySRu-2uySaR2+3J7qcw4O+JOepTwag@mail.gmail.com> <CAEiveUe87HZK45Vs1VsTKcPMpLAav53JZb9_5-3Bc--FCGDf3A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 23 Jan 2017 12:07:23 -0800
Message-ID: <CALCETrWa5kdm2kk_PmD5grgdO+geLvR2BacAZ7NhcHH-VeQh3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 23, 2017 at 3:46 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> On Sat, Jan 21, 2017 at 1:53 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> I agree that the kernel change to do it per task is very simple.  But
>> this is an unfortunate slippery slope.  What if you want to block off
>> everything in /proc that isn't associated with a PID?  What if you
>> want to suppress /sys access?  What if you want ot block *all*
>> non-current PIDs from being revealed in /proc?  What if you want to
>> hide /proc/PID/cmdline?
>
> For /sys we mount an inaccessible directory on top, we even do that
> for some static /sys and /proc inodes, of course that doesn't scale
> but we try... please see below.

So you do have a private fs namespace.

>
>> I think that the right solution here is to fix procfs to understand
>> per-superblock mount options.
>
> Unfortunately and as also noted by Lafcadio and you this is too
> complex.
> ... but lets please stay focused here, fixing procfs is a bit out of the
> scope for this *specific* use case and patch, we don't have the
> resources to explore something new...

I'm not the final authority on this (that's probably Eric), but NAK.
For upstream Linux, you can't say "doing it right is too hard so we're
going to introduce a hackish ABI with questionable security
properties".

The right solution is IMO quite clearly to fix /proc.  This isn't even
particularly hard -- there are only 17 instances of s_fs_info in
fs/proc/.

> ... Easy to review and maintain.

Au contraire.  It's a pain in the arse to review because of the
security implications and it's unpleasant to maintain because it's a
special case in core kernel code.
