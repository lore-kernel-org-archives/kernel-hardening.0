Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 30 Nov 2015 14:12:08 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
Message-ID: <20151130141208.516b1046@xeon-e3>
In-Reply-To: <87egf7183c.fsf_-_@x220.int.ebiederm.org>
References: <565B7F7D.80208@nod.at>
	<CAGXu5jJqQKAmFK0nL69E0QOpo8WSVDqStGZo7-m7gy3vnXBa=A@mail.gmail.com>
	<87egf7183c.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH net] bridge: Only call /sbin/bridge-stp for the initial
 network namespace
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>, Richard Weinberger <richard@nod.at>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, bridge@lists.linux-foundation.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 30 Nov 2015 15:38:15 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> There is no defined mechanism to pass network namespace information
> into /sbin/bridge-stp therefore don't even try to invoke it except
> for bridge devices in the initial network namespace.
> 
> It is possible for unprivileged users to cause /sbin/bridge-stp to be
> invoked for any network device name which if /sbin/bridge-stp does not
> guard against unreasonable arguments or being invoked twice on the same
> network device could cause problems.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  net/bridge/br_stp_if.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
> index 5396ff08af32..742fa89528ab 100644
> --- a/net/bridge/br_stp_if.c
> +++ b/net/bridge/br_stp_if.c
> @@ -142,7 +142,9 @@ static void br_stp_start(struct net_bridge *br)
>  	char *envp[] = { NULL };
>  	struct net_bridge_port *p;
>  
> -	r = call_usermodehelper(BR_STP_PROG, argv, envp, UMH_WAIT_PROC);
> +	r = -ENOENT;
> +	if (dev_net(br->dev) == &init_net)
> +		r = call_usermodehelper(BR_STP_PROG, argv, envp, UMH_WAIT_PROC);

I don't think this will cause loud screams.
But it might break people that use containers to run virtual networks for testing.

One coding nit:
Why are you afraid of using an else?
