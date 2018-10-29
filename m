Subject: Re: [PATCH 13/17] prmem: linked list: disable layout randomization
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-14-igor.stoppa@huawei.com> <20181024134343.GA7767@avx2>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <47d5706b-12b9-a94f-d668-8e9a659e33d0@gmail.com>
Date: Mon, 29 Oct 2018 21:40:27 +0200
MIME-Version: 1.0
In-Reply-To: <20181024134343.GA7767@avx2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Pekka Enberg <penberg@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Lihao Liang <lianglihao@huawei.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 24/10/2018 14:43, Alexey Dobriyan wrote:
> On Wed, Oct 24, 2018 at 12:35:00AM +0300, Igor Stoppa wrote:
>> Some of the data structures used in list management are composed by two
>> pointers. Since the kernel is now configured by default to randomize the
>> layout of data structures soleley composed by pointers,
> 
> Isn't this true for function pointers?

Yes, you are right.
Thanks for pointing this out.

I can drop this patch.

--
igor
