Date: Wed, 12 Dec 2018 16:29:47 +0000
From: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Message-ID: <ML-sxPRwNNExkZHkXghYN7e3VrhuZXYLjFv-aniX8qbjcde2GfHMBaI4B3A7IoUEfycQcWCPuxATkYHOz--FqMjH1KRwxMxBCb6Q-1IsKTM=@protonmail.ch>
In-Reply-To: <20181212081712.32347-1-mic@digikod.net>
References: <20181212081712.32347-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wednesday, December 12, 2018 9:17 AM, Micka=C3=ABl Sala=C3=BCn <mic@digi=
kod.net> wrote:

> Hi,
>
> The goal of this patch series is to control script interpretation. A
> new O_MAYEXEC flag used by sys_open() is added to enable userland script
> interpreter to delegate to the kernel (and thus the system security
> policy) the permission to interpret scripts or other files containing
> what can be seen as commands.
>
> The security policy is the responsibility of an LSM. A basic
> system-wide policy is implemented with Yama and configurable through a
> sysctl.
>
> The initial idea come from CLIP OS and the original implementation has
> been used for more than 10 years:
> https://github.com/clipos-archive/clipos4_doc
>
> An introduction to O_MAYEXEC was given at the Linux Security Summit
> Europe 2018 - Linux Kernel Security Contributions by ANSSI:
> https://www.youtube.com/watch?v=3DchNjCRtPKQY&t=3D17m15s
> The "write xor execute" principle was explained at Kernel Recipes 2018 -
> CLIP OS: a defense-in-depth OS:
> https://www.youtube.com/watch?v=3DPjRE0uBtkHU&t=3D11m14s
>
> This patch series can be applied on top of v4.20-rc6. This can be
> tested with CONFIG_SECURITY_YAMA. I would really appreciate
> constructive comments on this RFC.
>
> Regards,
>

Are various interpreters upstreams interested in adding support
for O_MAYEXEC if it land in kernel? Did you contacted them about this?

Jordan
