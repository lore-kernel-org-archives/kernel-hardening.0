MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180310094327.685d181d@epycfail>
References: <1520667645-21975-1-git-send-email-andreaschristofo@gmail.com> <20180310094327.685d181d@epycfail>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 10 Mar 2018 09:18:46 -0800
Message-ID: <CAGXu5jKwWRzK8EJOo2zraxi9ghQ7an5d4yr8ktGa+ijWX_aJZA@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv6: xfrm6_state: remove VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2018 at 12:43 AM, Stefano Brivio <sbrivio@redhat.com> wrote:
> On Sat, 10 Mar 2018 09:40:44 +0200
> Andreas Christoforou <andreaschristofo@gmail.com> wrote:
>
>> diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
>> index b15075a..270a53a 100644
>> --- a/net/ipv6/xfrm6_state.c
>> +++ b/net/ipv6/xfrm6_state.c
>> @@ -62,7 +62,7 @@ __xfrm6_sort(void **dst, void **src, int n, int (*cmp)(void *p), int maxclass)
>>  {
>>       int i;
>>       int class[XFRM_MAX_DEPTH];
>> -     int count[maxclass];
>> +     int count[XFRM_MAX_DEPTH];
>>
>>       memset(count, 0, sizeof(count));
>
> Can you perhaps initialize 'count' instead of calling memset(), now?

Do you mean:

int count[XFRM_MAX_DEPTH] = { };

instead of the memset()?

I thought the compiler would resolve these both to the same thing? The
former looks better though! :)

-Kees

-- 
Kees Cook
Pixel Security
