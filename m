Date: Wed, 14 Jun 2017 16:28:45 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170614142845.GA18999@openwall.com>
References: <20170608034349.31876-1-matt@nmatt.com> <20170608034349.31876-2-matt@nmatt.com> <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com> <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com> <20170613212704.GA16726@openwall.com> <CAG48ez2zdf93Eh=XoRsHRbF=YX6L_6B=qX=z7rbMQ6wtj6KVjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2zdf93Eh=XoRsHRbF=YX6L_6B=qX=z7rbMQ6wtj6KVjA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution as a stackable LSM
To: Jann Horn <jannh@google.com>
Cc: Matt Brown <matt@nmatt.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 14, 2017 at 03:15:22PM +0200, Jann Horn wrote:
> Some random related issues:
> 
> Scripts with shebang lines like "#!/usr/bin/env python" probably wouldn't
> work anymore, at least not without special-case logic, because in this case,
> env has to invoke python.

Why would this break?  If both env and python are in trusted paths, it
should work with TPE just fine.  (But then TPE is rather ineffective.)

> ssh and ssh-agent can load libraries from paths passed on the command
> line, by design.
> The alsa client library loads libraries from paths specified in user-owned
> config files.
> 
> If you can use dd (or anything else that permits writing to a specific
> position in a
> file), you should be able to directly overwrite the memory of a
> process using something like
> "dd of=/proc/self/mem bs=1 seek=$STARTADDRESS < new_data".
> I think one way to do this remotely is to use SFTP.

IIRC, /proc/self/mem requires mmap() and won't work with dd's write().

> Bash has a built-in named "enable" that can load shared libraries directly
> into the shell.
> 
> These are just some random examples I came up with relatively quickly,
> there are probably more.

Thanks.  The ssh, alsa, and bash "enable" examples are probably valid.

Alexander
