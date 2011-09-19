Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com> <20110630075716.GB3377@albatros>
 <BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com> <BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
 <BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Sep 2011 09:40:19 -0700
Message-ID: <CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
Content-Type: multipart/mixed; boundary=0016e65b62c4caa4d804ad4e00c4
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Balbir Singh <bsingharora@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--0016e65b62c4caa4d804ad4e00c4
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jun 30, 2011 at 8:02 PM, Balbir Singh <bsingharora@gmail.com> wrote:
>>
>> So that's why I think it should be marked BROKEN. What applications
>> actually depend on this? iotop and what else? Because if it's just
>> iotop, I do suspect we might be better off telling people "ok,
>> disabling this will break iotop, but quite frankly, you're better off
>> without it".
>
> I beg to differ, due to the reasons above. I'd rather find time and
> fix the pending issues (network namespace), you've fixed the pid
> namespace issue. I'd also look for exiting listeners

So nothing ever happened on this thread, afaik.

You can still read sensitive information at a byte granularity with taskstats.

Balbir never sent any of the fixes he was supposed to, and none of the
namespace issues have gotten fixed.

It's now almost three months later, and things are still equally broken.

I think we need to just disable TASKSTAT's. Nobody maintains it, it's
been a known issue for months, people pointed out problems and even
sent patches, and nothing happened.

Maybe we can minimize it with the appended patch, but dammit, we need
to do *something*. If I don't get any reasonable replies, I'm really
going to have to mark this as known-BROKEN, since nothing ever
happens, and the "maintainer" clearly doesn't care about security
issues.

                         Linus

--0016e65b62c4caa4d804ad4e00c4
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsroiqf40

IGtlcm5lbC90YXNrc3RhdHMuYyB8ICAgIDIgKysKIGtlcm5lbC90c2FjY3QuYyAgICB8ICAgIDcg
KysrKy0tLQogMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEva2VybmVsL3Rhc2tzdGF0cy5jIGIva2VybmVsL3Rhc2tzdGF0cy5jCmlu
ZGV4IGUxOWNlMTQ1NGVlMS4uNTg3NGQ0ODY2YjNjIDEwMDY0NAotLS0gYS9rZXJuZWwvdGFza3N0
YXRzLmMKKysrIGIva2VybmVsL3Rhc2tzdGF0cy5jCkBAIC00NTcsNiArNDU3LDggQEAgc3RhdGlj
IGludCBjbWRfYXR0cl9yZWdpc3Rlcl9jcHVtYXNrKHN0cnVjdCBnZW5sX2luZm8gKmluZm8pCiAJ
Y3B1bWFza192YXJfdCBtYXNrOwogCWludCByYzsKIAorCWlmICghY2FwYWJsZShDQVBfU1lTX0FE
TUlOKSkKKwkJcmV0dXJuIC1FUEVSTTsKIAlpZiAoIWFsbG9jX2NwdW1hc2tfdmFyKCZtYXNrLCBH
RlBfS0VSTkVMKSkKIAkJcmV0dXJuIC1FTk9NRU07CiAJcmMgPSBwYXJzZShpbmZvLT5hdHRyc1tU
QVNLU1RBVFNfQ01EX0FUVFJfUkVHSVNURVJfQ1BVTUFTS10sIG1hc2spOwpkaWZmIC0tZ2l0IGEv
a2VybmVsL3RzYWNjdC5jIGIva2VybmVsL3RzYWNjdC5jCmluZGV4IDI0ZGM2MGQ5ZmExZi4uMTEw
Y2E1YTAzYmQ2IDEwMDY0NAotLS0gYS9rZXJuZWwvdHNhY2N0LmMKKysrIGIva2VybmVsL3RzYWNj
dC5jCkBAIC03OCw2ICs3OCw3IEBAIHZvaWQgYmFjY3RfYWRkX3RzayhzdHJ1Y3QgdGFza3N0YXRz
ICpzdGF0cywgc3RydWN0IHRhc2tfc3RydWN0ICp0c2spCiAKICNkZWZpbmUgS0IgMTAyNAogI2Rl
ZmluZSBNQiAoMTAyNCpLQikKKyNkZWZpbmUgS0JfTUFTSyAofihLQi0xKSkKIC8qCiAgKiBmaWxs
IGluIGV4dGVuZGVkIGFjY291bnRpbmcgZmllbGRzCiAgKi8KQEAgLTEwMCw5ICsxMDEsOSBAQCB2
b2lkIHhhY2N0X2FkZF90c2soc3RydWN0IHRhc2tzdGF0cyAqc3RhdHMsIHN0cnVjdCB0YXNrX3N0
cnVjdCAqcCkKIAlzdGF0cy0+cmVhZF9zeXNjYWxscwk9IHAtPmlvYWMuc3lzY3I7CiAJc3RhdHMt
PndyaXRlX3N5c2NhbGxzCT0gcC0+aW9hYy5zeXNjdzsKICNpZmRlZiBDT05GSUdfVEFTS19JT19B
Q0NPVU5USU5HCi0Jc3RhdHMtPnJlYWRfYnl0ZXMJPSBwLT5pb2FjLnJlYWRfYnl0ZXM7Ci0Jc3Rh
dHMtPndyaXRlX2J5dGVzCT0gcC0+aW9hYy53cml0ZV9ieXRlczsKLQlzdGF0cy0+Y2FuY2VsbGVk
X3dyaXRlX2J5dGVzID0gcC0+aW9hYy5jYW5jZWxsZWRfd3JpdGVfYnl0ZXM7CisJc3RhdHMtPnJl
YWRfYnl0ZXMJPSBwLT5pb2FjLnJlYWRfYnl0ZXMgJiBLQl9NQVNLOworCXN0YXRzLT53cml0ZV9i
eXRlcwk9IHAtPmlvYWMud3JpdGVfYnl0ZXMgJiBLQl9NQVNLOworCXN0YXRzLT5jYW5jZWxsZWRf
d3JpdGVfYnl0ZXMgPSBwLT5pb2FjLmNhbmNlbGxlZF93cml0ZV9ieXRlcyAmIEtCX01BU0s7CiAj
ZWxzZQogCXN0YXRzLT5yZWFkX2J5dGVzCT0gMDsKIAlzdGF0cy0+d3JpdGVfYnl0ZXMJPSAwOwo=
--0016e65b62c4caa4d804ad4e00c4--
