Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAPDLWs8g5CRTDwDuuLuuGh8K30Py_kGkjVfuT++Q09rT6XaQ=A@mail.gmail.com>
References: <CAPDLWs8g5CRTDwDuuLuuGh8K30Py_kGkjVfuT++Q09rT6XaQ=A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 9 Jan 2017 16:27:09 -0800
Message-ID: <CAGXu5j+oOJoJ3JFzEpv4jNeCLu95-QVfYQ8mP-M-waqyvoDDRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] New to KSPP, would like to contribute
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 6, 2017 at 11:43 PM, Kaiwan N Billimoria
<kaiwan@kaiwantech.com> wrote:
> Hi All,
>
> Am new to the KSPP project, I find the area and work interesting.
> I have been exploring the Linux kernel for over 10 years now, and have
> contributed a couple of times to mainline (hwmon drivers). I maintain a few
> small, interesting to me, OSS projects on github.
>
> I read your page here, you've mentioned a TODO list, though am unsure where
> to start. Kernel security work is interesting to me, within task management
> and mm (I broadly understand these areas).
> Could you pl point me in an appropriate direction so that I can get started
> on KSPP?

Hi!

Welcome to the list! If you're familiar with mm areas, I'd say a great
place to start would be to help finish up the zero-poisoning work,
especially extracting the optimizations that PaX did for slabs to
avoid, etc. After that, collecting all the settings into a single
CONFIG_* would be great. Right now things are kind of scattered around
between CONFIG and kernel boot parameters. You can read about it here:

https://outflux.net/blog/archives/2016/09/30/security-things-in-linux-v4-6/

Thanks!

-Kees

-- 
Kees Cook
Nexus Security
