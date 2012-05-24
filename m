Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4FBECAC2.6050303@zytor.com>
Date: Thu, 24 May 2012 16:56:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20120522173942.GJ11775@ZenIV.linux.org.uk> <1337875681-20717-1-git-send-email-wad@chromium.org> <alpine.LRH.2.02.1205250932270.26644@tundra.namei.org> <CAObL_7GHEdoyzVPjhR5U0RvQhRP50e6YM83CkXifzUKOFb+KHQ@mail.gmail.com>
In-Reply-To: <CAObL_7GHEdoyzVPjhR5U0RvQhRP50e6YM83CkXifzUKOFb+KHQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 0/3] move the secure_computing call
To: Andrew Lutomirski <luto@mit.edu>
Cc: James Morris <jmorris@namei.org>, Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, mcgrathr@google.com, indan@nul.nu, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk
List-ID: <kernel-hardening.lists.openwall.com>

On 05/24/2012 04:43 PM, Andrew Lutomirski wrote:
> 
> IMO the behavior should change.  Alternatively, a post-ptrace syscall
> should have to pass the *tracer's* seccomp filter, but that seems
> overcomplicated and confusing.
> 
> OTOH, allowing ptrace in a seccomp filter is asking for trouble anyway
> -- if you can ptrace something outside the sandbox, you've escaped.
> 

This is my suggestion: if there is demand, make it possible to install a
*second* seccomp filter program which is run on the result of the
ptrace.  I.e.:

Untraced:	process -> seccomp1 -> kernel

Traced:		process -> seccomp1 -> ptrace -> seccomp2 -> kernel

This is something we could add later if there is demand.

	-hpa
