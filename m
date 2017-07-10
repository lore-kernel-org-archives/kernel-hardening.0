MIME-Version: 1.0
In-Reply-To: <53a2d710-b0f0-cdf9-e7ad-cd8d03fc835a@digikod.net>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com> <53a2d710-b0f0-cdf9-e7ad-cd8d03fc835a@digikod.net>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 10 Jul 2017 09:59:03 +0200
Message-ID: <CAJHCu1+=uYQ-N7CH4KfmTHrN2hJjwzN0tgg4sWHU0LjVr+uGGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] [PATCH 00/11] S.A.R.A. a new stacked LSM
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Matt Brown <matt@nmatt.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-07-09 21:35 GMT+02:00 Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>:
> Hi,
>
> I think it make sense to merge the W^X features with the TPE/shebang LSM
> [1].
>
> Regards,
>  Micka=C3=ABl
>
> [1]
> https://lkml.kernel.org/r/d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.ne=
t

Hi,
Can you elaborate why it would be an advantage to have those features merge=
d?
They seem quite unrelated.
Also, they work in rather different ways in respect to how they are configu=
red.
I'm not sure what would be a reasonable way to merge them.
Thank you for your comment,

Salvatore
