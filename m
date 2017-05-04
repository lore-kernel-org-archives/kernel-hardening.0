Message-ID: <1493906699.29205.1.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Thu, 04 May 2017 10:04:59 -0400
In-Reply-To: <20170504133209.3053-1-danielmicay@gmail.com>
References: <20170504133209.3053-1-danielmicay@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH] use get_random_long for the per-task
 stack canary
To: Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>, Arjan van Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
Cc: stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-05-04 at 09:32 -0400, Daniel Micay wrote:
> The stack canary is an unsigned long and should be fully initialized
> to
> random data rather than only 32 bits of random data.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Micay <danielmicay@gmail.com>
> 
Acked-by: Rik van Riel <riel@redhat.com>
