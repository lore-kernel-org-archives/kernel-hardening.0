Date: Tue, 14 Feb 2017 16:34:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20170214163406.1ed8e7d707510d14137f1dd6@linux-foundation.org>
In-Reply-To: <CAGXu5jLKqKso-FGDfr=2_xu+k15Lz-T9CgT_4ZvEEeZ9G1+LzA@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
	<1484572984-13388-2-git-send-email-djalal@gmail.com>
	<CAGXu5jLKqKso-FGDfr=2_xu+k15Lz-T9CgT_4ZvEEeZ9G1+LzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 1/2] procfs: use an enum for possible hidepid values
To: Kees Cook <keescook@chromium.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Lafcadio Wluiki <wluikil@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 13 Feb 2017 14:16:30 -0800 Kees Cook <keescook@chromium.org> wrote:

> On Mon, Jan 16, 2017 at 5:23 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> > From: Lafcadio Wluiki <wluikil@gmail.com>
> >
> > Previously, the hidepid parameter was checked by comparing literal
> > integers 0, 1, 2. Let's add a proper enum for this, to make the checking
> > more expressive:
> >
> >         0 ___ HIDEPID_OFF
> >         1 ___ HIDEPID_NO_ACCESS
> >         2 ___ HIDEPID_INVISIBLE
> >
> > This changes the internal labelling only, the userspace-facing interface
> > remains unmodified, and still works with literal integers 0, 1, 2.
> >
> > No functional changes.
> >
> > Acked-by: Kees Cook <keescook@chromium.org>
> > Acked-by: Djalal Harouni <tixxdz@gmail.com>
> > Signed-off-by: Lafcadio Wluiki <wluikil@gmail.com>
> 
> Andrew, can you take this? It's a sensible cleanup to drop literals in
> favor of defines.

Sure.

Djalal, I converted your acked-by into a signed-off-by, as described in
Documentation/SubmittingPatches (soon to become
Documentation/process/submitting-patches.rst).
