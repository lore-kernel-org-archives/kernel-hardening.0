MIME-Version: 1.0
In-Reply-To: <20170919003707.GA25217@openwall.com>
References: <1505465028-15256-1-git-send-email-s.mesoraca16@gmail.com>
 <CAGXu5jLRn3_gCb4F5EyUXSk=JOW-yzftST3z2XA3Kner21d=bw@mail.gmail.com> <20170919003707.GA25217@openwall.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 19 Sep 2017 18:06:15 +0200
Message-ID: <CAJHCu1+mpA-7eSFNZoGpOMNuts4ZmKMGQCWGORuA0jH_KW6aHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC] Restrict writes into untrusted FIFOs and regular files
To: Solar Designer <solar@openwall.com>
Cc: Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

2017-09-19 2:37 GMT+02:00 Solar Designer <solar@openwall.com>:
> On Mon, Sep 18, 2017 at 02:00:50PM -0700, Kees Cook wrote:
>> On Fri, Sep 15, 2017 at 1:43 AM, Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
>> > The purpose is to make data spoofing attacks harder.
>>
>> Do you have any examples of attacks (CVEs, blog posts, etc) that you
>> could link to in this commit?
>
> I doubt there are (m)any examples of attacks and blog posts on this,
> because most systems didn't have similar (sym)link restrictions until
> recently and those attacks are simpler.  As to CVEs, I expect that a
> large subset of CVEs assigned to "improper usage of temporary files" or
> "symlink attacks" or such are about vulnerabilities that are also
> exploitable into data spoofing, even if perhaps with different (and
> often lesser) impact than they are when exploited via (sym)links.
>
> IIRC, the attacks were first pointed out on LKML circa 1997 as an
> argument against (sym)link restrictions - that they're not enough on
> their own against some attacks anyway, because FIFOs and even regular
> files could also be used for those.  My response was to include FIFO
> restrictions (on top of (sym)link restrictions) into -ow patches, and
> now the same became relevant for mainline (as it has the optional
> (sym)link restrictions now).
>
> One thing that has changed since is the addition of inotify, which
> probably made use of regular files for similar attacks much more
> practical.  This is one reason why we might also protect against
> maybe-maliciously pre-created regular files now.
>
> Another reason is that we, or at least some users/sysadmins, may want to
> discourage misuse of /tmp, /dev/shm, and similar directories in general.
> Those directories are supposed to only be accessed through appropriate
> library interfaces, or using specific known-safe procedures.  Trying to
> O_CREAT a file in there without O_EXCL is almost never right.  It makes
> sense to provide an easy way to disallow that as policy enforcement.
>
>> bike shed: I think "_files" is redundant, since we're already in proc/sys/fs/
>
> +1
>
>> > +protected_regular_files:
>> > +
>> > +This protection is similar to protected_fifos, but it
>> > +avoids writes to an attacker-controlled regular file, where program
>> > +expected to create one.
>> > +
>> > +When set to "0", regular files writing is unrestricted.
>> > +
>> > +When set to "1" don't allow O_CREAT open on regular files that we
>> > +don't own in world writable sticky directories, unless they are
>> > +owned by the owner of the directory.
>> > +
>> > +This protection is based on the restrictions in Openwall.
>
> While symlink/hardlink/FIFO restrictions were in -ow patches, the
> regular file restriction was not - we're just inventing it now, even if
> upon my suggestion.

Oh OK, I thought it was fair to add that line because the code of the regular
file part is practically identical to the code of the FIFO part, but I'll remove
that line in the next version.

> Although this is sufficient against attacks (if the kernel's check for
> these properties is not racy; I don't know if it is), for the policy
> enforcement use case and reason we might want to support a simpler mode
> where O_CREAT without O_EXCL would be disallowed in sticky directories
> (only world writable? or also writable by anyone other than us? - e.g.,
> it'd catch some unsafe uses of mail spools) regardless of whether a
> file of that name already exists or not.  Maybe extra settings:
>
> When set to "2" also don't allow O_CREAT open without O_EXCL in
> world-writable sticky directories (even if the files don't already
> exist, for consistent policy enforcement)
>
> When set to "3" also don't allow O_CREAT open on regular files that we
> don't own in sticky directories writable by anyone else, unless the
> files are owned by the owner of the directory.
>
> When set to "4" also don't allow O_CREAT open without O_EXCL in
> sticky directories writable by anyone else (even if the files don't
> already exist, for consistent policy enforcement)
>
> Or maybe "2" and "4" should be a separate knob, so that "3" could be
> used without the policy enforcement aspect of "2", although enabling
> this separate knob at the highest level would make protected_regular
> redundant.
>
> I could envision further levels for non-sticky world-writable and
> writable-by-others directories, and even for unsafe writes without
> O_CREAT and unsafe reads, but then the protected_regular name would
> become even more misleading as without O_CREAT the program could
> actually intend to work with a non-regular file.
>
> Let's avoid further scope creep for now, but have this in mind.  As I
> had mentioned in another thread on kernel-hardening, policy enforcement
> like this implemented in a kernel module helped me find weaknesses in
> old Postfix' privsep implementation, which were promptly patched (that
> was many years ago).  Having this generally available and easy to enable
> could result in more findings like this by more people.
>
> A setting similar to "3" above should probably also exist for
> protected_fifos (would be "2" there).

I think I could add "3" to both protected_fifos and protected_regulars
actually using "2" for both. And then add another sysctl for modes
"2" and "4" for both fifos and regular files.

>> Otherwise, yeah, looks good! :)
>
> +1

Thank you very much for your time!

Salvatore
