MIME-Version: 1.0
In-Reply-To: <20170603055351.16080-1-matt@nmatt.com>
References: <20170603055351.16080-1-matt@nmatt.com>
From: Jann Horn <jannh@google.com>
Date: Sat, 3 Jun 2017 12:39:03 +0200
Message-ID: <CAG48ez1W6Pwxuhc92OGvtmLQLE8XhXCJvZDoqDCMSODvtGUT_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as a
 stackable LSM
To: Matt Brown <matt@nmatt.com>
Cc: james.l.morris@oracle.com, serge@hallyn.com, kernel list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 3, 2017 at 7:53 AM, Matt Brown <matt@nmatt.com> wrote:
> This patch was modified from Brad Spengler's Trusted Path Execution (TPE)
> feature in Grsecurity and also incorporates logging ideas from
> cormander's tpe-lkm.
>
> Modifications from the Grsecurity implementation of TPE were made to
> turn it into a stackable LSM using the existing LSM hook bprm_set_creds.
> Also, denial messages were improved by including the full path of the
> disallowed program. (This idea was taken from cormander's tpe-lkm)
[...]
> Threat Models:
[...]
> 2. Attacker on system replaces binary used by a privileged user with a
>    malicious one
>
> *  This situation arises when administrator of a system leaves a binary
>    as world writable.
>
> *  TPE is very effective against this threat model

How do you end up with world-writable binaries in $PATH?
