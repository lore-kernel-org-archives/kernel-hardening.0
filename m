Date: Mon, 5 Jun 2017 16:30:00 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170605163000.2b7f16d1@lxorguk.ukuu.org.uk>
In-Reply-To: <20170603055351.16080-1-matt@nmatt.com>
References: <20170603055351.16080-1-matt@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 1/1] Add Trusted Path Execution as a stackable LSM
To: Matt Brown <matt@nmatt.com>
Cc: james.l.morris@oracle.com, serge@hallyn.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> | A trusted path is one that is inside is a root owned directory that
> | is not group or world writable.  /bin, /usr/bin, /usr/local/bin, are
> | (under normal circumstances) considered trusted.  Any non-root
> | users home directory is not trusted, nor is /tmp.

You need the entire path to be root owned and root write only from /, and
to assume that the attacker can't get CAP_SYS_DAC. Compare that with
labelling and labelling looks rather better.

It's the same story as ever - paths are not very meaningful for security,
content is. You label content not paths. The existing LSMs can provide
both content label based execution protection and even path based.
SELinux can do it right already, AppArmor appears to be able to do it
compatibly wrong with your proposal already.

> NOTE: root is never restricted by TPE

Why are we talking about "root" not capabilities ? We stopped tying stuff
to "root" 20 years ago.

>    *  Can be bypassed by interpreted languages such as python. You can run
>       malicious code by doing: python -c 'evil code'

Or using ld.so since ELF binaries are dynamically loaded and will even
helpfully trying and dynamically load libraries not on your trust path
completely configurably via environment variables.

So all your funky protection goes to poop the moment you hit the most
wannabe n00b attacker who knows how to set LD_PRELOAD.

The unix x bit was never designed as a security feature. It got slightly
tweaked for one for directory path walking but the purpose of the 'x' bit
on a file is solely to stop the user accidentally executing garbage.

> 2. Attacker on system replaces binary used by a privileged user with a
>    malicious one
> 
> *  This situation arises when administrator of a system leaves a binary
>    as world writable.
> 
> *  TPE is very effective against this threat model

Keeping the executables root is allowed to use in a root owned, only root
reachable space with no setuid bits works even better. Especially as you
can mount it r/o almost all of the time.

Pleae explain how your filesystem mode checks interact with existing file
systems that implement other security semantics eg OpenAFS, or for that
matter DOS ?

[Not an idle question as most distributions keep their EFI system
partition mounted even though it seems a rather silly thing to do]

Alan
