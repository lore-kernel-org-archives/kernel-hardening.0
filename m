References: <1513549807-20287-1-git-send-email-me@tobin.cc>
 <1513549807-20287-3-git-send-email-me@tobin.cc>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f1da002e-f982-7a3e-f539-17f3dac3a914@infradead.org>
Date: Sun, 17 Dec 2017 18:48:45 -0800
MIME-Version: 1.0
In-Reply-To: <1513549807-20287-3-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 2/3] doc: update kpt_restrict documentation
To: "Tobin C. Harding" <me@tobin.cc>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 12/17/2017 02:30 PM, Tobin C. Harding wrote:
> Recently the behaviour of printk specifier %pK was changed. The
> documentation does not currently mirror this.
> 
> Update documentation for sysctl kpt_restrict.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  Documentation/sysctl/kernel.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 63663039acb7..6b039aa1427a 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -391,7 +391,8 @@ kptr_restrict:
>  This toggle indicates whether restrictions are placed on
>  exposing kernel addresses via /proc and other interfaces.
>  
> -When kptr_restrict is set to (0), the default, there are no restrictions.
> +When kptr_restrict is set to (0), the default, the address is hashed before

how about:
                      is set to 0 (the default),
or
                      is set to (0) [the default],


> +printing. (This is the equivalent to %p.)
>  
>  When kptr_restrict is set to (1), kernel pointers printed using the %pK
>  format specifier will be replaced with 0's unless the user has CAP_SYSLOG
> 


-- 
~Randy
