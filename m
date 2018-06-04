Subject: Re: [PATCH] proc: prevent a task from writing on its own /proc/*/mem
References: <1527346246-1334-1-git-send-email-s.mesoraca16@gmail.com>
 <CAGXu5j+PHzDwnJxJwMJ=WuhacDn_vJWe9xZx+Kbsh28vxOGRiA@mail.gmail.com>
 <CA+55aFx6DBp+d33_fytOGPWw11xg_L0MdGp1M2e5Obc0N9kMRQ@mail.gmail.com>
 <CAJHCu1Ky09DWskcD4nVW5u1C5faWMv1A4kcxWzdiap7+G1SPkg@mail.gmail.com>
 <CABxV-EWN8ag2zk2CDxWyC3+DvuM3ADbf=qGm4uczK8YnOd5JBQ@mail.gmail.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <8dc3efeb-ddf7-ca15-d70f-b6c32dea4eb6@schaufler-ca.com>
Date: Mon, 4 Jun 2018 11:03:18 -0700
MIME-Version: 1.0
In-Reply-To: <CABxV-EWN8ag2zk2CDxWyC3+DvuM3ADbf=qGm4uczK8YnOd5JBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Steve Kemp <steve.backup.kemp@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/4/2018 9:57 AM, Steve Kemp wrote:
>> A configurable LSM is probably the right way to do this.
> I wonder how many out of tree LSM there are?  Looking at the mainline
> kernel the only "small" LSM bundled is YAMA, and it seems that most of
> the patches proposing new ones eventually die out.

LoadPin is upstream.

> I appreciate that there are probably a lot of "toy" or "local" modules
> out there for specific fields, companies, or products, but it does
> seem odd that there are so few discussed publicly.

Minor modules like Yama and LoadPin are constrained by not being
able to use security blobs. That seriously limits the sort of thing
you can do with them. It often makes more sense to get the behavior
in mainline under CONFIG_SOMETHING than to provide a minor LSM in
that case.

> (The last two I remember were S.A.R.A and something relating to
> xattr-attributes being used to whitelist execution.)

Anything that would have to be a major (blob using) module has
a very tough time because you have to displace an existing major
module (SELinux, AppArmor, Smack, TOMOYO) in order to use it.
When we get infrastructure managed security blobs upstream most
of the proposed modules could be used in conjunction with the
existing installed modules. Some would have to wait for the
complete stacking solution, but that's limited to use of networking
facilities.

There's also renewed interest in minor modules being dynamically
loadable, so they can be added on a running system as new and
interesting threats get newer and more interesting mitigations.

We don't make it easy for new modules. Some of that is an
artifact of the infrastructure, and some is based on caution.

> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
