Message-ID: <1491582353.8850.169.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Fri, 07 Apr 2017 12:25:53 -0400
In-Reply-To: <1491513513-84351-17-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
	 <1491513513-84351-17-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 16/18] task_struct: Allow randomized
 layout
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-04-06 at 14:18 -0700, Kees Cook wrote:

> One question about formatting remains: should this patch indent all
> the
> randomized fields, due to the added anonymous struct, which would
> make
> this patch white-space huge, or should I leave the indentation level
> alone, to avoid massive churn? I opted for making the patch more
> readable, but can easily do the indentation...

It may make sense to do the indentation in a separate
patch, for readability reasons.
