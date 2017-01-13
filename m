Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Fri, 13 Jan 2017 21:35:48 +0100
MIME-Version: 1.0
Message-ID: <58793A24.22555.3425E964@pageexec.freemail.hu>
In-reply-to: <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>, <5879219B.26854.33C60FDB@pageexec.freemail.hu>, <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Introduction
To: Kees Cook <keescook@chromium.org>
Cc: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 13 Jan 2017 at 11:06, Kees Cook wrote:

> Out of curiosity, do you remember which bug? I'd be curious to compare
> it against others. It seems like adding structleak to upstream still
> has value, even if the coverage isn't as complete as stackleak.

i think it was CVE-2013-2141 where siginfo has at least one __user ptr field.
