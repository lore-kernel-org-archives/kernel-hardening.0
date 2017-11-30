Date: Thu, 30 Nov 2017 20:14:38 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20171130191438.GA4646@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com> <20171127011441.GA15063@openwall.com> <CAJHCu1+wC1BsW2r77aoibFth_qtjozKZFJTaD4xCuGBzHp2s4w@mail.gmail.com> <20171130190539.GA4360@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130190539.GA4360@openwall.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 30, 2017 at 08:05:39PM +0100, Solar Designer wrote:
> A new thought: a directory that has someone else as its owner is for our
> purposes effectively the same as a group-writable directory.  So maybe
> whatever we'll implement for group-writable directories should also be
> done for directories that have other than the current fsuid as their
> owner.  It's currently very uncommon to have directories with the sticky
> bit set that are not at least group-writable, so this will rarely make a
> difference (and when it does, that's just right), but also it provides a
> way to explicitly include any directory under this monitoring (if the
> group-writable protection is on) - e.g., if a sysadmin wants this
> monitoring for users' home directories, they can change permissions for
> those from e.g. 700 to 1700.  This could be handy for development and
> auditing of software, even though in production it could be easily
> circumvented by the directory owner (who can remove the sticky bit,
> which we should document to avoid providing a false sense of security)
> and it won't automatically apply to subdirectories.  It'd also cover
> part of what we intend to achieve later by possibly extending the
> feature to non-sticky directories, where we might also want to treat
> different owner the same as group-writable (without the circumvention).

Of course, where I wrote "other than the current fsuid", it should be "a
non-root user other than the current fsuid".  We trust root.

Alexander
