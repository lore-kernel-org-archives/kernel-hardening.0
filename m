MIME-Version: 1.0
In-Reply-To: <CAG48ez3UTpmkZ=VnSeD=LfistvsSQ6dFe_R4opbTcHhfgzo-gQ@mail.gmail.com>
References: <20170608034349.31876-1-matt@nmatt.com> <20170608034349.31876-2-matt@nmatt.com>
 <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com>
 <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com> <20170613212704.GA16726@openwall.com>
 <CAG48ez2zdf93Eh=XoRsHRbF=YX6L_6B=qX=z7rbMQ6wtj6KVjA@mail.gmail.com>
 <20170614142845.GA18999@openwall.com> <CAG48ez3UTpmkZ=VnSeD=LfistvsSQ6dFe_R4opbTcHhfgzo-gQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 14 Jun 2017 16:34:11 +0200
Message-ID: <CAG48ez3Q0YMmnutKeUuGO+Vg_UPbcv9AyG7QEK=ajwuGQRfrUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution
 as a stackable LSM
To: Solar Designer <solar@openwall.com>
Cc: Matt Brown <matt@nmatt.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 14, 2017 at 4:33 PM, Jann Horn <jannh@google.com> wrote:
> On Wed, Jun 14, 2017 at 4:28 PM, Solar Designer <solar@openwall.com> wrote:
>> On Wed, Jun 14, 2017 at 03:15:22PM +0200, Jann Horn wrote:
>>> Some random related issues:
>>>
>>> Scripts with shebang lines like "#!/usr/bin/env python" probably wouldn't
>>> work anymore, at least not without special-case logic, because in this case,
>>> env has to invoke python.
>>
>> Why would this break?  If both env and python are in trusted paths, it
>> should work with TPE just fine.  (But then TPE is rather ineffective.)
>
> I think somewhere in this thread, or a related one, it was suggested to have
> some mechanism to only prevent execution of e.g. python as an interpreter,
> not direct execution.

s/prevent/permit/
