Reply-To: kernel-hardening@lists.openwall.com
References: <1453622354-50686-1-git-send-email-sbauer@eng.utah.edu>
 <1453622354-50686-2-git-send-email-sbauer@eng.utah.edu>
 <87twlsaw92.fsf@rasmusvillemoes.dk>
From: Scotty Bauer <sbauer@eng.utah.edu>
Message-ID: <56AFE7EE.30100@eng.utah.edu>
Date: Mon, 1 Feb 2016 16:19:10 -0700
MIME-Version: 1.0
In-Reply-To: <87twlsaw92.fsf@rasmusvillemoes.dk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 1/2] SROP Mitigation: Architecture independent code
 for signal cookies
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, kernel-hardening@lists.openwall.com
Cc: abhiram@cs.utah.edu
List-ID: <kernel-hardening.lists.openwall.com>



On 02/01/2016 03:42 PM, Rasmus Villemoes wrote:
> On Sun, Jan 24 2016, Scott Bauer <sbauer@eng.utah.edu> wrote:
> 
>> This patch adds a per-process secret to the task struct which
>> will be used during signal delivery and during a sigreturn.
>> Also, logic is added in signal.c to generate, place, extract,
>> clear and verify the signal cookie.
>>
>>  
>> +static unsigned long gen_sigcookie(unsigned long __user *location)
>> +{
>> +
>> +	unsigned long sig_cookie;
>> +
>> +	sig_cookie = (unsigned long) location ^ current->sig_cookie;
>> +
>> +	sig_cookie = hash_long(sig_cookie, sizeof(sig_cookie) * BITS_PER_BYTE);
>> +
>> +	return sig_cookie;
>> +}
> 
> Is current->sig_cookie supposed to be secret, as in unknown to
> userspace? If so, this won't work, as hash_long (with BIT_PER_LONG as
> nbits parameter) is invertible (since we've just multiplied by an odd
> number and right-shifted by 0). Maybe xoring with some global secret
> afterwards would fix this, though I'm not sure.
> 
> Rasmus
> 

Maybe secret is a bad term. It's supposed to be something userland can't guess 
without doing a bunch of tricks. It's essentially supposed to work like a stack
canary to protect against stack based buffer overflows. If someone can leak the
stack canary in a stack based overflow, then do the overflow they can overcome 
stack canaries as a mitigation. The same is true here. If someone can generate a
signal, leak the signal cookie, then leak the address of the signal cookie, then
undo the hash, then they can beat this mitigation. But we're arguing if someone
can do everything we've said above they have already have nearly full control of
a userland process and they won't really need SROP.

Essentially the signal cookie is just a way for the kernel to know if the 
sigreturn it's handling is in response to a legitimate signal that the kernel 
previously delivered without having to save a ton of state in current, or 
elsewhere. 
