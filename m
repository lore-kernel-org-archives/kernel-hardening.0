References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608034349.31876-2-matt@nmatt.com>
 <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com>
 <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com>
 <1497003507.21594.177.camel@linux.vnet.ibm.com>
 <CAGXu5jKWJV34g5TMDtJLTxF1irijay7KMK3s5oxz8ZYTJZkV5Q@mail.gmail.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <4bf3331c-9c02-1d76-01a8-92290800db7c@nmatt.com>
Date: Fri, 9 Jun 2017 09:15:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKWJV34g5TMDtJLTxF1irijay7KMK3s5oxz8ZYTJZkV5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution as a stackable LSM
To: Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/9/17 8:55 AM, Kees Cook wrote:
> On Fri, Jun 9, 2017 at 3:18 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> On Thu, 2017-06-08 at 23:50 -0400, Matt Brown wrote:
>>>>>
>>>>> *  Issues:
>>>>>    *  Can be bypassed by interpreted languages such as python. You can run
>>>>>       malicious code by doing: python -c 'evil code'
>>>>
>>>> What's the recommendation for people interested in using TPE but
>>>> having interpreters installed?
>>>>
>>>
>>> If you don't need a given interpreter installed, uninstall it. While
>>> this is common sense system hardening it especially would make a
>>> difference under the TPE threat model.
>>>
>>> I don't have a knock down answer for this. Interpreters are a hard
>>> problem for TPE.
>>
>> You might be interested in the minor LSM named "shebang", that I
>> posted as a proof of concept back in January, which restricts the
>> python interactive prompt/interpreter, but allows the scripts
>> themselves to be executed.
> 
> https://patchwork.kernel.org/patch/9547405/
> 
> Maybe these could be merged and the interpreter string could be made
> into a configurable list?
> 

Yes this looks promising. I'll look into integrating this.

Matt
