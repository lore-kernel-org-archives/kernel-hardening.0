MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <a5e688c4-94b8-b0aa-4425-fc687d3aeeca@redhat.com>
References: <a5e688c4-94b8-b0aa-4425-fc687d3aeeca@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 14 Feb 2017 11:07:39 -0800
Message-ID: <CAGXu5jLre9QdOWi+-GxcGi=rxp=Emwnaz=MBxDtdd_ZD=VRc2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Format string gcc-plugin?
To: Laura Abbott <labbott@redhat.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 10:01 AM, Laura Abbott <labbott@redhat.com> wrote:
> Hi,
>
> The recent discussions about %pk led me to start playing around
> with writing a gcc plugin (notes about writing a gcc plugin are
> forthcoming). My idea was to expand checking of the kernel's additional
> formats (%pK, %pR etc.) or possibly even change the format
> strings. The big issue is that most of vsprintf.c would end up
> in the plugin which would be ugly to maintain. This concept could
> be used for some of the problems with kernel pointer leaks
> https://kernsec.org/wiki/index.php/Bug_Classes/Kernel_pointer_leak
> but I'm interested if anyone else has thoughts or ideas about
> how better to do this (or even not to do this).

If we can leverage common code between the plugin and vsprintf.c, it
should be doable. I haven't looked at processing format strings at
all, though I assume the plugin would need to check the
__printf-generated attributes.

In my related notes was a hint that looking at how gcc does it
normally is gcc/c-family/c-format.c:
http://stackoverflow.com/a/16336175

And while not strictly part of format type checking, I talked a bit
about dealing with const strings here:
http://www.openwall.com/lists/kernel-hardening/2016/12/07/16

-Kees

-- 
Kees Cook
Pixel Security
