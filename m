Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+rpMbKZkFRQ6cq-Rgic8XXiV-kh+n0PmNiHwm9mCDdxN_xmCw@mail.gmail.com>
References: <CA+rpMbL84wDu8e_QzZ86Hp3inrkbdb4XPh41OTV0zdB13cnzwg@mail.gmail.com>
 <CA+rpMbKEFd_vNKaV_+H_dfQX2r=FwxkhP7VbPRyFG04qO6srGw@mail.gmail.com>
 <CA+rpMbKpMGo7YOvroc6YskTOSHFG7m0Wz7-WFieHvGT1ew+YLA@mail.gmail.com>
 <CA+rpMbLYAX14OdD1OOCJ_ZWv6_qs2WxnP=tycoiXFxvasRLLLA@mail.gmail.com>
 <CA+rpMb+dnqmf8JYE4Y5oXNXihba_=-jddyhoFoLj8fxfo8AEfw@mail.gmail.com>
 <CA+rpMbJGWcF=Xa7r=NiBzaqo061GnunhE9eZXdhYMAxgJTaF9w@mail.gmail.com>
 <CA+rpMbLj8WSfmvP0x7SU2VDa09cvwZYm=cfgO-C3E-fvc+_acw@mail.gmail.com>
 <CA+rpMb+tupmqJTCSR9Vkf0N2DEZfOY8ResWCWQTYv2U_eLCRBA@mail.gmail.com>
 <CA+rpMb+vgSh=XPcGrofaopFsdjHMvUMsYubG_2D4CTW4XUaqmg@mail.gmail.com>
 <CA+rpMb+r9P86q+9i0vHfuXYpyY2F8YVQMwWAGTq2=+EwyhxrnA@mail.gmail.com>
 <CA+rpMb+sEZgJLp2Cv9Vtka5Jw=_HiLwgB7WDfKZmkMf_w6bn7A@mail.gmail.com>
 <CA+rpMbLSGALyN15+MEFGo2-N+gZ5SA0b_2urcLww1Z8X3d3wDA@mail.gmail.com>
 <CA+rpMbKBfkS2HNKeYS5CF2YU6S+aCaA=x6Ao0Khn8B64RU5OmA@mail.gmail.com>
 <CA+rpMb+web7zD0FmPPRqa+RH1r9V+=yyUvTD0YDCkWVF1fQ_yg@mail.gmail.com>
 <CA+rpMbJRciGmHgpzn7Tyn-9k+ksRzHROT4wcVC6gPrjv+H2rgQ@mail.gmail.com>
 <CA+rpMbK+aDEDHQZPmuD=Z1NO5U9ifGCF7J6H9voMXRjnPugn9w@mail.gmail.com>
 <CA+rpMbK5D5srxhD+oH2QL8RavHNhQh=Bha8WV0N9neRfXvRMKA@mail.gmail.com> <CA+rpMbKZkFRQ6cq-Rgic8XXiV-kh+n0PmNiHwm9mCDdxN_xmCw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 28 Nov 2016 12:51:56 -0800
Message-ID: <CAGXu5jKpNAVb657-d1zTu2dCgWhLUG0PkQmMx=orDCyB9vr_2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction and task pick
To: Gaurav Minocha <gaurav.minocha.os@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 17, 2016 at 6:06 PM, Gaurav Minocha
<gaurav.minocha.os@gmail.com> wrote:
> Hello,
>
> I have been contributing in kernel as a hobbyist in device tree area. Still,
> a kernel newbie. Here, my intent is to explore kernel and learn its design.

Hi! Welcome to the fun!

> Write a plugin to clear struct padding - If no one has started it, I believe
> this task would be a good start. Could someone please share more
> details..like similar plugin, problem and suggested solution?

I would look at the PaX plugin "structleak_plugin.c", which does this
already, IIUC, and see what is needed (if anything) to port it to the
upstream kernel's gcc plugins.

The easiest way to examine the plugin is to grab the latest grsecurity patch:
https://grsecurity.net/download.php#test

and then look for PAX_MEMORY_STRUCTLEAK (defined in arch/Kconfig) and
the plugin itself in scripts/gcc-plugins/

> Please let me know if I'm missing something.
>
> Note: I contribute in my free time in multiple projects, so if task is
> urgent, please let me know in advance.

For the Kernel Self-Protection Project, getting it done right and well
documented and tested is better than speed. Having both is nice, but
generally it's harder to find people interested in the work; no need
to rush people. :)

-Kees

-- 
Kees Cook
Nexus Security
