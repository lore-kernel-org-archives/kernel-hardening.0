Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120406125517.77133b4e.akpm@linux-foundation.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-2-git-send-email-wad@chromium.org>
	<20120406125517.77133b4e.akpm@linux-foundation.org>
Date: Tue, 10 Apr 2012 14:03:49 -0500
Message-ID: <CABqD9hbTWQ6uBn_jZ7WdbaAMtAcTHz3hWSer_tnAFU9iV-4GSQ@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v17 01/15] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve
 from granting privs
To: Andrew Morton <akpm@linux-foundation.org>, Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, jmorris@namei.org, Andy Lutomirski <luto@amacapital.net>, linux-man@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 6, 2012 at 2:55 PM, Andrew Morton <akpm@linux-foundation.org> w=
rote:
> On Thu, 29 Mar 2012 15:01:46 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> From: Andy Lutomirski <luto@amacapital.net>
>>
>> With this set, a lot of dangerous operations (chroot, unshare, etc)
>> become a lot less dangerous because there is no possibility of
>> subverting privileged binaries.
>
> The changelog doesn't explain the semantics of the new syscall.
> There's a comment way-down-there which I guess suffices, if you hunt
> for it.

I'll bubble up luto's comment into the changelog when I resend the
grand-unified-patchset.

> And the changelog doesn't explain why this is being added. =A0Presumably
> seccomp_filter wants/needs this feature but whowhatwherewhenwhy? =A0Spell
> it all out, please.

I'll try my hand at that and luto@ can yell at me if I misrepresent.
Seem reasonable?

> The new syscall mode will be documented in the prctl manpage. =A0Please
> cc linux-man@vger.kernel.org and work with Michael on getting this
> done?

I'll add linux-man to the patch series since this applies to both
no_new_privs and seccomp filter.

Thanks!

>>
>> ...
>>
