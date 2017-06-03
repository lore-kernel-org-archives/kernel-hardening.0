Message-ID: <1496492078.21640.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 03 Jun 2017 08:14:38 -0400
In-Reply-To: <CAGXu5jLfUj9TP6=nVcBy43-Etz6NAeA5kStEpwNRfNNLATEKjQ@mail.gmail.com>
References: <20170602152010.2064-1-riel@redhat.com>
	 <CAGXu5jLfUj9TP6=nVcBy43-Etz6NAeA5kStEpwNRfNNLATEKjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 0/6] move mmap_area and PIE binaries
 away from the stack
To: Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Larry Woodman <lwoodman@redhat.com>, mhocko@suse.de, Will Deacon <will.deacon@arm.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-06-02 at 21:37 -0700, Kees Cook wrote:
> 
> Patches 3 and 4 need some (minor?) adjustments

It's currently a bug fix. Doing something further would be more than
fixing the bug and should probably be separate.
