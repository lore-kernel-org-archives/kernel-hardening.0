MIME-Version: 1.0
In-Reply-To: <9f197147-c050-dd70-23ea-ec880d205201@oracle.com>
References: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com> <9f197147-c050-dd70-23ea-ec880d205201@oracle.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 12 Mar 2018 11:12:57 +0100
Message-ID: <CAJHCu1+afx1jMA1eAsEdrqLBN1o=ndQUXEheEteVw+VHEwZJdg@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: rds: drop VLA in rds_for_each_conn_info()
Content-Type: text/plain; charset="UTF-8"
To: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-03-12 8:06 GMT+01:00 santosh.shilimkar@oracle.com
<santosh.shilimkar@oracle.com>:
> On 3/11/18 2:07 PM, Salvatore Mesoraca wrote:
>>
>> Avoid VLA[1] by using an already allocated buffer passed
>> by the caller.
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>>
>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>> ---
>
> Thanks for both VLA fixes Salvatore.
>
> FWIW, Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

Thank you very much for your time,

Salvatore
