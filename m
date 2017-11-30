Date: Thu, 30 Nov 2017 11:16:19 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171130001619.GR6217@eros>
References: <1511821819-5496-1-git-send-email-me@tobin.cc>
 <1511821819-5496-2-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511821819-5496-2-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] Re: [RFC 1/3] kallsyms: don't leak address when symbol not found
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tycho Andersen <tycho@tycho.ws>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

I reordered the To's and CC's, I hope this doesn't break
threading. (clearly I haven't groked email yet :( ) 

On Tue, Nov 28, 2017 at 09:30:17AM +1100, Tobin C. Harding wrote:
> Currently if kallsyms_lookup() fails to find the symbol then the address
> is printed. This potentially leaks sensitive information. Instead of
> printing the address we can return an error, giving the calling code the
> option to print the address or print some sanitized message.
> 
> Return error instead of printing address to argument buffer. Leave
> buffer in a sane state.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  kernel/kallsyms.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 531ffa984bc2..4bfa4ee3ce93 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -394,8 +394,10 @@ static int __sprint_symbol(char *buffer, unsigned long address,
>  
>  	address += symbol_offset;
>  	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
> -	if (!name)
> -		return sprintf(buffer, "0x%lx", address - symbol_offset);
> +	if (!name) {
> +		buffer[0] = '\0';
> +		return -1;
> +	}
>  
>  	if (name != buffer)
>  		strcpy(buffer, name);
> -- 
> 2.7.4
> 

Do you want a Suggested-by: tag for this patch Steve? I mentioned you in
the cover letter but as far as going into the git history I'm not
entirely sure on the protocol for adding suggested-by. The kernel docs
say not to add it without authorization, so ...

thanks,
Tobin.
