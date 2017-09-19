Date: Tue, 19 Sep 2017 18:34:44 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170919163443.GA29644@openwall.com>
References: <1505465028-15256-1-git-send-email-s.mesoraca16@gmail.com> <CAGXu5jLRn3_gCb4F5EyUXSk=JOW-yzftST3z2XA3Kner21d=bw@mail.gmail.com> <20170919003707.GA25217@openwall.com> <CAJHCu1+mpA-7eSFNZoGpOMNuts4ZmKMGQCWGORuA0jH_KW6aHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHCu1+mpA-7eSFNZoGpOMNuts4ZmKMGQCWGORuA0jH_KW6aHw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC] Restrict writes into untrusted FIFOs and regular files
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 19, 2017 at 06:06:15PM +0200, Salvatore Mesoraca wrote:
> 2017-09-19 2:37 GMT+02:00 Solar Designer <solar@openwall.com>:
> > On Mon, Sep 18, 2017 at 02:00:50PM -0700, Kees Cook wrote:
> >> On Fri, Sep 15, 2017 at 1:43 AM, Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
> >> > +protected_regular_files:
> >> > +
> >> > +This protection is similar to protected_fifos, but it
> >> > +avoids writes to an attacker-controlled regular file, where program
> >> > +expected to create one.
> >> > +
> >> > +When set to "0", regular files writing is unrestricted.
> >> > +
> >> > +When set to "1" don't allow O_CREAT open on regular files that we
> >> > +don't own in world writable sticky directories, unless they are
> >> > +owned by the owner of the directory.
[...]
> > Although this is sufficient against attacks (if the kernel's check for
> > these properties is not racy; I don't know if it is), for the policy
> > enforcement use case and reason we might want to support a simpler mode
> > where O_CREAT without O_EXCL would be disallowed in sticky directories
> > (only world writable? or also writable by anyone other than us? - e.g.,
> > it'd catch some unsafe uses of mail spools) regardless of whether a
> > file of that name already exists or not.  Maybe extra settings:
> >
> > When set to "2" also don't allow O_CREAT open without O_EXCL in
> > world-writable sticky directories (even if the files don't already
> > exist, for consistent policy enforcement)
> >
> > When set to "3" also don't allow O_CREAT open on regular files that we
> > don't own in sticky directories writable by anyone else, unless the
> > files are owned by the owner of the directory.
> >
> > When set to "4" also don't allow O_CREAT open without O_EXCL in
> > sticky directories writable by anyone else (even if the files don't
> > already exist, for consistent policy enforcement)
> >
> > Or maybe "2" and "4" should be a separate knob, so that "3" could be
> > used without the policy enforcement aspect of "2", although enabling
> > this separate knob at the highest level would make protected_regular
> > redundant.
> >
> > I could envision further levels for non-sticky world-writable and
> > writable-by-others directories, and even for unsafe writes without
> > O_CREAT and unsafe reads, but then the protected_regular name would
> > become even more misleading as without O_CREAT the program could
> > actually intend to work with a non-regular file.
> >
> > Let's avoid further scope creep for now, but have this in mind.  As I
> > had mentioned in another thread on kernel-hardening, policy enforcement
> > like this implemented in a kernel module helped me find weaknesses in
> > old Postfix' privsep implementation, which were promptly patched (that
> > was many years ago).  Having this generally available and easy to enable
> > could result in more findings like this by more people.
> >
> > A setting similar to "3" above should probably also exist for
> > protected_fifos (would be "2" there).
> 
> I think I could add "3" to both protected_fifos and protected_regulars
> actually using "2" for both. And then add another sysctl for modes
> "2" and "4" for both fifos and regular files.

Sounds good to me.  The third sysctl (or several) could be introduced
with a separate patch, focusing on file access safety policy warnings
and enforcement in general rather than on any specific file types.

Alexander
