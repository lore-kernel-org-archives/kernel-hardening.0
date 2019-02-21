MIME-Version: 1.0
References: <CALS6=qWHytpevcJqB6TkgzUfUmpoxVeyJtvEKigJH3-cnw7vUQ@mail.gmail.com>
In-Reply-To: <CALS6=qWHytpevcJqB6TkgzUfUmpoxVeyJtvEKigJH3-cnw7vUQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 17:17:07 -0800
Message-ID: <CAGXu5jKoHfPHadabqo=7FaOD1O-GRE1-GowfmZSs_oB+snWFaQ@mail.gmail.com>
Subject: Re: classes of methods for gaining access to kernel memory
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Carter Cheng <cartercheng@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 10, 2019 at 3:13 AM Carter Cheng <cartercheng@gmail.com> wrote:
> I was reading a paper on kernel data attacks and the paper mentions metho=
ds for gaining control of kernel memory beyond overflow type attacks. This =
would seem to suggest that methods exist for this in certain cases beyond w=
hat can be caught by spatial safety checks. Are there general classes of su=
ch methods that one needs to be aware of? And what are they?

If I follow what you're asking, I'd think race conditions would be an
example of another major class of attacks against the kernel. For
example, look at the DirtyCOW attack: that was a race condition
against the kernel's VFS that wouldn't get caught by bounds checking,
etc, etc.

--=20
Kees Cook
