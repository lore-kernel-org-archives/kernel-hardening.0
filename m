MIME-Version: 1.0
In-Reply-To: <CABxV-EWN8ag2zk2CDxWyC3+DvuM3ADbf=qGm4uczK8YnOd5JBQ@mail.gmail.com>
References: <1527346246-1334-1-git-send-email-s.mesoraca16@gmail.com>
 <CAGXu5j+PHzDwnJxJwMJ=WuhacDn_vJWe9xZx+Kbsh28vxOGRiA@mail.gmail.com>
 <CA+55aFx6DBp+d33_fytOGPWw11xg_L0MdGp1M2e5Obc0N9kMRQ@mail.gmail.com>
 <CAJHCu1Ky09DWskcD4nVW5u1C5faWMv1A4kcxWzdiap7+G1SPkg@mail.gmail.com> <CABxV-EWN8ag2zk2CDxWyC3+DvuM3ADbf=qGm4uczK8YnOd5JBQ@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 10 Jun 2018 09:40:53 +0200
Message-ID: <CAJHCu1LMzXeySHDXyXNpDbVjD2Lpu-dNTXFm3YhEuTnrU0tA9A@mail.gmail.com>
Subject: Re: [PATCH] proc: prevent a task from writing on its own /proc/*/mem
Content-Type: text/plain; charset="UTF-8"
To: Steve Kemp <steve.backup.kemp@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-06-04 18:57 GMT+02:00 Steve Kemp <steve.backup.kemp@gmail.com>:
>> A configurable LSM is probably the right way to do this.
>
> I wonder how many out of tree LSM there are?  Looking at the mainline
> kernel the only "small" LSM bundled is YAMA, and it seems that most of
> the patches proposing new ones eventually die out.
>
> I appreciate that there are probably a lot of "toy" or "local" modules
> out there for specific fields, companies, or products, but it does
> seem odd that there are so few discussed publicly.
>
> (The last two I remember were S.A.R.A and something relating to
> xattr-attributes being used to whitelist execution.)

FWIW S.A.R.A. is not dead [1].
Unfortunately it needs infrastructure managed security blobs, so I didn't
tried to get it upstream, yet.
Of course, I can't give you any guarantees about when or if it will be
upstreamed,
but it's definitely still alive.

[1] https://github.com/smeso/sara/releases/latest
