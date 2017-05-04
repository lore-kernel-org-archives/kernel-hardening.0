References: <20170504133209.3053-1-danielmicay@gmail.com>
From: Arjan van de Ven <arjan@linux.intel.com>
Message-ID: <e358b217-7bae-07bb-4245-12d62513c733@linux.intel.com>
Date: Thu, 4 May 2017 06:33:15 -0700
MIME-Version: 1.0
In-Reply-To: <20170504133209.3053-1-danielmicay@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] use get_random_long for the per-task stack canary
To: Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
Cc: stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 5/4/2017 6:32 AM, Daniel Micay wrote:
> The stack canary is an unsigned long and should be fully initialized to
> random data rather than only 32 bits of random data.

that makes sense to me... ack
