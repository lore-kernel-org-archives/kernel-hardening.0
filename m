Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 10 Mar 2017 08:25:07 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170310072507.GB4909@gmail.com>
References: <1488506159-3506-1-git-send-email-dwindsor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488506159-3506-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] refcount: add refcount_t API kernel-doc comments
To: David Windsor <dwindsor@gmail.com>
Cc: peterz@infradead.org, elena.reshetova@intel.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


* David Windsor <dwindsor@gmail.com> wrote:

> This adds kernel-doc comments for the new refcount_t API.
> 
> v2: incorporate fixes from Peter Zijlstra and Ingo Molnar
> 
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
>  lib/refcount.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 110 insertions(+), 12 deletions(-)

Patch does not apply cleanly anymore, could you please merge it to Linus's latest 
and resend?

Thanks!

	Ingo
