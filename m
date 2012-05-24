Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: amluto@gmail.com
In-Reply-To: <alpine.LRH.2.02.1205250932270.26644@tundra.namei.org>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk> <1337875681-20717-1-git-send-email-wad@chromium.org>
 <alpine.LRH.2.02.1205250932270.26644@tundra.namei.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 24 May 2012 16:43:29 -0700
Message-ID: <CAObL_7GHEdoyzVPjhR5U0RvQhRP50e6YM83CkXifzUKOFb+KHQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC PATCH 0/3] move the secure_computing call
To: James Morris <jmorris@namei.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, mcgrathr@google.com, hpa@zytor.com, indan@nul.nu, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 24, 2012 at 4:40 PM, James Morris <jmorris@namei.org> wrote:
> On Thu, 24 May 2012, Will Drewry wrote:
>
>> As is, the biggest benefit of this change is just setting consistent
>> expectations in what the ptrace/seccomp interactions should be. =A0The
>> current ability for ptrace to "bypass" secure computing (by remapping
>> allowed system calls) is not necessarily a problem, but it is not
>> necessarily intuitive behavior.
>
> Indeed -- while the purpose of seccomp is to reduce the attack surface of
> the syscall interface, if a user allows ptrace, attackers will definitely
> see that as an attack vector, if it allows them to increase that attack
> surface.
>
> It at least needs to be well-documented.

IMO the behavior should change.  Alternatively, a post-ptrace syscall
should have to pass the *tracer's* seccomp filter, but that seems
overcomplicated and confusing.

OTOH, allowing ptrace in a seccomp filter is asking for trouble anyway
-- if you can ptrace something outside the sandbox, you've escaped.

--Andy
