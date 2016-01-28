Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87wpqteh4y.fsf@x220.int.ebiederm.org>
References: <20160128143825.GA17383@www.outflux.net>
	<87wpqteh4y.fsf@x220.int.ebiederm.org>
Date: Thu, 28 Jan 2016 12:08:10 -0800
Message-ID: <CAGXu5jJZbWikFf5DpAioq=E7k0KdXxM7g=ML4CiO-+W3sqop4A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] sysctl: allow CLONE_NEWUSER to be disabled
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Lutomirski <luto@kernel.org>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Richard Weinberger <richard@nod.at>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 28, 2016 at 9:41 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> There continue to be unexpected security exposures when users have access
>> to CLONE_NEWUSER.
>
> So how does this sucessfully address that issue?

I've explained this several times. It disables new user namespaces.
I've asked earlier but got no answer: is revocation a requirement for
this feature?

>> For admins of systems that do not use user namespaces
>> and are running distro kernels with CONFIG_USER_NS enabled, there is
>> no way to disable CLONE_NEWUSER. This provides a way for sysadmins to
>> disable the feature to reduce their attack surface without needing to
>> rebuild their kernels.
>>
>> This is inspired by a similar restriction in Grsecurity, but adds
>> a sysctl.
>>
>
> I have already nacked this patch.   Thank you for removing the broken
> capability in sysctl check.  But this does not address any of the other
> issues I have raised.

I also asked about implementation directions but got no reply: do you
want this as an rlimit, or something else?

> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Further as far as I can tell this is just about a witch hunt.  Isn't
> that what you call a campaign against something when the complaining
> party does not understand something persecutes it and does not bother to
> try and understand?
>
> I have already told you what kind of direction would be acceptable.  I
> gave concrete suggests and here you are wasting our time with this patch
> again.

I wanted to have a "clean" version of the sysctl patch and figured I'd
share it since it was the implementation that Andy and others had
showed interest in, even if it won't be the final version of this
feature.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
