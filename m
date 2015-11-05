Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
Date: Thu, 5 Nov 2015 12:59:21 -0800
Message-ID: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Kernel Self Protection Project
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Solar Designer <solar@openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>
List-ID: <kernel-hardening.lists.openwall.com>

I'm organizing a community of people to work on the various kernel
self-protection technologies (most of which are found in PaX and
Grsecurity). I'm building on the presentation I gave at Kernel Summit
where I sought to convince the other upstream Linux kernel developers
that security is more than fixing bugs, and that we need to bring in
proactive defenses:
http://lwn.net/Articles/662219/

This is especially highlighted by the Washington Post article today:
http://www.washingtonpost.com/sf/business/2015/11/05/net-of-insecurity-the-kernel-of-the-argument/

Between the companies that recognize the critical nature of this work,
and with Linux Foundation's Core Infrastructure Initiative happy to
start funding specific work in this area, I think we can really make a
dent.

Let's start the work. I've built some wiki pages around my slides,
where we can take notes, list examples, and coordinate:
http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project

For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
gcc plugin, which will also get us the gcc plugin infrastructure.
Other people, please speak up on what you'd like to tackle.

I recommend PAX_REFCOUNT, PAX_USERCOPY, and GRKERNSEC_KSTACKOVERFLOW
for some non-plugin stuff to look at.

Once we've got plugins, then we should look at PAX_MEMORY_STACKLEAK
and PAX_CONSTIFY_PLUGIN.

If you're feeling like disrupting people who depend on debugging, do
GRKERNSEC_HIDESYM.

If you're feeling especially bold, start on PAX_KERNEXEC and follow it
up with PAX_MEMORY_UDEREF.

Of course, there's plenty of other things, and tons I haven't listed
in the wiki -- please add them and bring them up for discussion here.

-Kees

-- 
Kees Cook
Chrome OS Security
