Reply-To: kernel-hardening@lists.openwall.com
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
 <20160422202248.f3a31c6956a9135e9bdc0205@gmail.com>
From: Michal Marek <mmarek@suse.com>
Message-ID: <5733166E.4070401@suse.com>
Date: Wed, 11 May 2016 13:24:30 +0200
MIME-Version: 1.0
In-Reply-To: <20160422202248.f3a31c6956a9135e9bdc0205@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v7 2/6] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2016-04-22 20:22, Emese Revfy wrote:
> diff --git a/Documentation/dontdiff b/Documentation/dontdiff
> index 8ea834f..5385cba 100644
> --- a/Documentation/dontdiff
> +++ b/Documentation/dontdiff
> @@ -3,6 +3,7 @@
>  *.bc
>  *.bin
>  *.bz2
> +*.c.[012]*.*
>  *.cis
>  *.cpio
>  *.csp

Hi Emese,

Where are these files generated? It should be added to .gitignore and
the clean or mrproper rule if it's needed.

Michal
