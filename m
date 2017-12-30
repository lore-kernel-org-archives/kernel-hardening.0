Date: Sat, 30 Dec 2017 21:30:55 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171230103055.GC6042@caerus>
References: <1513569287.8041.8.camel@gmail.com>
 <20171218055746.GC4627@eros>
 <20171226074855.43205509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171226074855.43205509@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add generic 32-bit support
To: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 26, 2017 at 07:48:55AM +0530, Kaiwan N Billimoria wrote:
> The script attempts to detect the architecture it's running upon; as of now,
> we explicitly support x86_64, PPC64 and x86_32.
> If it's one of them, we proceed "normally". If we fail to detect the arch,
> we fallback to 64-bit scanning, unless the user has passed either of these
> option switches: "--opt-32bit" and/or "--page-offset-32bit=<val>".
> 
> If so, we switch to scanning for leaked addresses based on the value of
> PAGE_OFFSET (via an auto-detected or fallback mechanism).
> 
> As of now, we have code (or "rules") to detect special cases for x86_64 and PPC64
> (in the get_address_re sub). Also, we now have also builtin "stubs", for lack of a better term, where additional rules for other 64-bit arch's can be plugged into the code,
> in future, as applicable.
> 
> Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> 
> ---
>  scripts/leaking_addresses.pl | 190 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 156 insertions(+), 34 deletions(-)
> 
> This patch is based on Tobin's suggestions and my replies to them (see prev email in this thread).

Hi,

Can you resend this with a version number please. Also can you include what testing you have done
please. I'm away on Christmas holidays at the moment but I'll review soon as I'm back.

Thanks,
Tobin.
