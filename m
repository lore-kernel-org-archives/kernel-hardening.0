Subject: Re: [PATCH 2/2] net: rds: drop VLA in rds_walk_conn_path_info()
References: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com>
 <1520802470-17374-2-git-send-email-s.mesoraca16@gmail.com>
From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Message-ID: <07a52b72-5ecf-2027-0e87-e16dc0a70d09@oracle.com>
Date: Mon, 12 Mar 2018 00:06:29 -0700
MIME-Version: 1.0
In-Reply-To: <1520802470-17374-2-git-send-email-s.mesoraca16@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 3/11/18 2:07 PM, Salvatore Mesoraca wrote:
> Avoid VLA[1] by using an already allocated buffer passed
> by the caller.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
