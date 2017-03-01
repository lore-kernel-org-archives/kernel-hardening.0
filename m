Message-ID: <1488330874.25838.43.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 28 Feb 2017 17:14:34 -0800
In-Reply-To: <CAGXu5j+dZvZPnmWMVsgSL706m_mR+h7FGd1HS4TgKmXhYhA4Hw@mail.gmail.com>
References: 
	<476DC76E7D1DF2438D32BFADF679FC562307BAE6@ORSMSX103.amr.corp.intel.com>
	 <163a690510e636a23187c0dc9caa09ddac6d4cde.1488228427.git.joe@perches.com>
	 <20170228160607.183a88bd491e97fa6a7ded9c@linux-foundation.org>
	 <CAGXu5j+dZvZPnmWMVsgSL706m_mR+h7FGd1HS4TgKmXhYhA4Hw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] checkpatch: Add ability to find
 bad uses of vsprintf %p<foo> extensions
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, "Roberts, William C" <william.c.roberts@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-02-28 at 16:11 -0800, Kees Cook wrote:
> On Tue, Feb 28, 2017 at 4:06 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 27 Feb 2017 12:54:55 -0800 Joe Perches <joe@perches.com> wrote:
> > 
> > > %pK was at least once misused at %pk in an out-of-tree module.
> > > This lead to some security concerns.  Add the ability to track
> > > single and multiple line statements for misuses of %p<foo>.
> > 
> > Should we also do this?
> 
> Ah yes, good idea. Maybe "...when adding/removing new conversion..." ?

Deleting conversions seems unlikely.
