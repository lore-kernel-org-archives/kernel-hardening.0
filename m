Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 23 Mar 2017 08:40:01 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170323074001.GB14258@gmail.com>
References: <1489160052-20293-1-git-send-email-dwindsor@gmail.com>
 <CAGXu5jJuzpSeosAQxkewWB3804+pUrJ9HiU3p-8SOo2hTwFwbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJuzpSeosAQxkewWB3804+pUrJ9HiU3p-8SOo2hTwFwbQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3] refcount: add refcount_t API kernel-doc comments
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dwindsor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> On Fri, Mar 10, 2017 at 7:34 AM, David Windsor <dwindsor@gmail.com> wrote:
> > v3: rebase against latest Linus tree; re-add include/linux/refcount.h
> > missing from v2 series
> >
> > Signed-off-by: David Windsor <dwindsor@gmail.com>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> Ingo, can you pull this into tip? I like having more documentation here. :)

So I hopped into my time machine and applied it to tip:locking/core as of March 
13th:

  commit bd174169c7a12a37b3b4aa2221f084ade010b182
  Author:     David Windsor <dwindsor@gmail.com>
  AuthorDate: Fri Mar 10 10:34:12 2017 -0500
  Commit:     Ingo Molnar <mingo@kernel.org>
  CommitDate: Mon Mar 13 07:41:08 2017 +0100

You are welcome! ;-)

Thanks,

	Ingo
