Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <563D1B35.7010603@digikod.net>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<563D1B35.7010603@digikod.net>
Date: Fri, 6 Nov 2015 14:04:07 -0800
Message-ID: <CAGXu5jJYv+eZOWkoRU0jJL9UxmTJLV5unNvkR6TcwT+dLYpuHg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Kernel Self Protection Project
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Solar Designer <solar@openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Mathias Krause <minipli@googlemail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 6, 2015 at 1:27 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> Excellent initiative!
>
> FYI, you can find the grsecurity patches automatically integrated in a co=
nsistent Git repository: https://github.com/linux-scraping/linux-grsecurity=
 . I took all patches I could find (with their signatures and changelogs!),=
 starting from the beginning of the Linux Git history (2005: v2.6.14.2), an=
d applying them following branches and merges. The result is quite interest=
ing and help to dive into the Linux/grsecurity internals (with log, blame a=
nd bisect). Moreover, it show the work of Brad Spengler backporting fixes.
> I did the same with PaX but it needs some more work before going public.

Thanks for the pointer! This could be a nice resource for people who
want to take a closer look at the history.

Related to resources, I also think it'd be great to start a collection
of relevant academic papers too, and get them linked off the wiki.
Does anyone have a few they think are especially notable?

-Kees

--=20
Kees Cook
Chrome OS Security
