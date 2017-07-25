MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <91431.1500952906@turing-police.cc.vt.edu>
References: <91431.1500952906@turing-police.cc.vt.edu>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Jul 2017 13:16:58 -0700
Message-ID: <CAGXu5j+OnEHFsOLVXpw5F0igkwR8UJQF4tS99J3Vhza3sN_zjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Issue with CONFIG_GCC_PLUGIN_RANDSTRUCT=y and
 out of tree modules..
To: "Valdis.Kletnieks@vt.edu" <valdis.kletnieks@vt.edu>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 8:21 PM,  <valdis.kletnieks@vt.edu> wrote:
> I discovered the hard way that changing that config variable from n to y
> and then doing a 'make' of an out of tree module resulted in it not working.

Hm, I'd need to know more details, but normally switching out the gcc
plugin config should trigger a full rebuild.

> Once I did a 'make clean', the next 'make' resulted in a working module.
> So I'm guessing that the kernel dependencies were too subtle for
> the 'make' to notice that the structures had changed logically, if not
> source code wise.  Probably not fixable, but could probably use
> a line or two in the Kconfig help for the item.
>
> I'll code a patch if that seems like a good idea...

Yeah, "make clean" would fix it. If you see a solution for what you
saw, yeah, send a patch. :)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
