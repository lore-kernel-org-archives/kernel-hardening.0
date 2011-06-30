Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com> <20110630075716.GB3377@albatros>
 <BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Jun 2011 09:40:52 -0700
Message-ID: <BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
Content-Type: multipart/mixed; boundary=001517402310aa7fcc04a6f091d7
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Balbir Singh <bsingharora@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001517402310aa7fcc04a6f091d7
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jun 30, 2011 at 3:59 AM, Balbir Singh <bsingharora@gmail.com> wrote:
> On Thu, Jun 30, 2011 at 1:27 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> On Wed, Jun 29, 2011 at 13:09 -0700, Linus Torvalds wrote:
>>> Ok, having looked at this some more, I'm quite ready to just mark the
>>> whole TASKSTATS config option as BROKEN. It does seem to be a horrible
>>> security hazard, and very little seems to use it.
>>>
>
> I am not sure how you define BROKEN, BROKEN as per security rules?
> /proc/$pid/xxx also expose similar information.

No it doesn't.

/proc/$pid/xyz has always had proper security checks. Now, sometimes
they've been a bit too lax (iow, we've had cases where we just allowed
things we shouldn't - like this "io" file), but /proc/pid/ at least
*conceptually* has always had the "do I have permission to read this
or not". Do a "cat /proc/*/* > /dev/null" and you'll be getting a lot
of "permission denied" etc.

TASKSTATS? Nothing. Nada. Completely open.

That's just broken.

TASKSTATS also isn't apparently used by any normal program, and so
never got updated to namespaces. Again, /proc/xyz/ at least *tries*:
I'm not guaranteeing that it doesn't have some gaping holes, but I can
at least find the logic that saves and uses namespace information.

Again, TASKSTATS? Not so much.

> I must admit, I did not pay much attention to pid namespace changes as
> they were being made to taskstats. I'll look at the code later this
> week.

Some of the pid namespace issues could be fixed with the attached kind
of starting point.

But it's broken. See the comment I added. Why is it broken? Again -
taskstats is fundamentally broken, and doesn't seem to actually clean
up after itself. The "cleanup" depends on noticing at run-time that
some pid is stale and no longer listening. Again, that's just
fundamental brokenness in taskstats.

And it also only look sat pid namespaces. The network namespace issue
is separate.

So that's why I think it should be marked BROKEN. What applications
actually depend on this? iotop and what else? Because if it's just
iotop, I do suspect we might be better off telling people "ok,
disabling this will break iotop, but quite frankly, you're better off
without it".

                          Linus

--001517402310aa7fcc04a6f091d7
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpjxuoeh0

IGtlcm5lbC90YXNrc3RhdHMuYyB8ICAgMTYgKysrKysrKysrKysrKystLQogMSBmaWxlcyBjaGFu
Z2VkLCAxNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5l
bC90YXNrc3RhdHMuYyBiL2tlcm5lbC90YXNrc3RhdHMuYwppbmRleCBmYzBmMjIwMDU0MTcuLjYy
MGU4OWFlOTZjZiAxMDA2NDQKLS0tIGEva2VybmVsL3Rhc2tzdGF0cy5jCisrKyBiL2tlcm5lbC90
YXNrc3RhdHMuYwpAQCAtMjcsNiArMjcsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2Nncm91cC5oPgog
I2luY2x1ZGUgPGxpbnV4L2ZzLmg+CiAjaW5jbHVkZSA8bGludXgvZmlsZS5oPgorI2luY2x1ZGUg
PGxpbnV4L3BpZF9uYW1lc3BhY2UuaD4KICNpbmNsdWRlIDxuZXQvZ2VuZXRsaW5rLmg+CiAjaW5j
bHVkZSA8YXNtL2F0b21pYy5oPgogCkBAIC02MCw2ICs2MSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1
Y3QgbmxhX3BvbGljeSBjZ3JvdXBzdGF0c19jbWRfZ2V0X3BvbGljeVtDR1JPVVBTVEFUU19DTURf
QVRUUl9NCiBzdHJ1Y3QgbGlzdGVuZXIgewogCXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsKIAlwaWRf
dCBwaWQ7CisJc3RydWN0IHBpZF9uYW1lc3BhY2UgKnBpZF9uczsKIAljaGFyIHZhbGlkOwogfTsK
IApAQCAtMTI3LDYgKzEyOSw3IEBAIHN0YXRpYyBpbnQgc2VuZF9yZXBseShzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiLCBzdHJ1Y3QgZ2VubF9pbmZvICppbmZvKQogc3RhdGljIHZvaWQgc2VuZF9jcHVfbGlz
dGVuZXJzKHN0cnVjdCBza19idWZmICpza2IsCiAJCQkJCXN0cnVjdCBsaXN0ZW5lcl9saXN0ICps
aXN0ZW5lcnMpCiB7CisJc3RydWN0IHBpZF9uYW1lc3BhY2UgKmN1cnJlbnRfbnM7CiAJc3RydWN0
IGdlbmxtc2doZHIgKmdlbmxoZHIgPSBubG1zZ19kYXRhKG5sbXNnX2hkcihza2IpKTsKIAlzdHJ1
Y3QgbGlzdGVuZXIgKnMsICp0bXA7CiAJc3RydWN0IHNrX2J1ZmYgKnNrYl9uZXh0LCAqc2tiX2N1
ciA9IHNrYjsKQEAgLTE0MCw4ICsxNDMsMTUgQEAgc3RhdGljIHZvaWQgc2VuZF9jcHVfbGlzdGVu
ZXJzKHN0cnVjdCBza19idWZmICpza2IsCiAJfQogCiAJcmMgPSAwOworCWN1cnJlbnRfbnMgPSB0
YXNrX2FjdGl2ZV9waWRfbnMoY3VycmVudCk7CiAJZG93bl9yZWFkKCZsaXN0ZW5lcnMtPnNlbSk7
CiAJbGlzdF9mb3JfZWFjaF9lbnRyeShzLCAmbGlzdGVuZXJzLT5saXN0LCBsaXN0KSB7CisJCS8q
CisJCSAqIEJST0tFTjogd2hhdCBpZiAicyIgaXMgc3RhbGU/IFRoaXMgd2F5IGl0IHdpbGwKKwkJ
ICogbmV2ZXIgYmUgbWFya2VkIGludmFsaWQhCisJCSAqLworCQlpZiAocy0+cGlkX25zICE9IGN1
cnJlbnRfbnMpCisJCQljb250aW51ZTsKIAkJc2tiX25leHQgPSBOVUxMOwogCQlpZiAoIWxpc3Rf
aXNfbGFzdCgmcy0+bGlzdCwgJmxpc3RlbmVycy0+bGlzdCkpIHsKIAkJCXNrYl9uZXh0ID0gc2ti
X2Nsb25lKHNrYl9jdXIsIEdGUF9LRVJORUwpOwpAQCAtMjg3LDYgKzI5Nyw3IEBAIHN0YXRpYyBp
bnQgYWRkX2RlbF9saXN0ZW5lcihwaWRfdCBwaWQsIGNvbnN0IHN0cnVjdCBjcHVtYXNrICptYXNr
LCBpbnQgaXNhZGQpCiAJc3RydWN0IGxpc3RlbmVyX2xpc3QgKmxpc3RlbmVyczsKIAlzdHJ1Y3Qg
bGlzdGVuZXIgKnMsICp0bXAsICpzMjsKIAl1bnNpZ25lZCBpbnQgY3B1OworCXN0cnVjdCBwaWRf
bmFtZXNwYWNlICpwaWRfbnMgPSB0YXNrX2FjdGl2ZV9waWRfbnMoY3VycmVudCk7CiAKIAlpZiAo
IWNwdW1hc2tfc3Vic2V0KG1hc2ssIGNwdV9wb3NzaWJsZV9tYXNrKSkKIAkJcmV0dXJuIC1FSU5W
QUw7CkBAIC0zMDAsMTMgKzMxMSwxNCBAQCBzdGF0aWMgaW50IGFkZF9kZWxfbGlzdGVuZXIocGlk
X3QgcGlkLCBjb25zdCBzdHJ1Y3QgY3B1bWFzayAqbWFzaywgaW50IGlzYWRkKQogCQkJaWYgKCFz
KQogCQkJCWdvdG8gY2xlYW51cDsKIAkJCXMtPnBpZCA9IHBpZDsKKwkJCXMtPnBpZF9ucyA9IHBp
ZF9uczsKIAkJCUlOSVRfTElTVF9IRUFEKCZzLT5saXN0KTsKIAkJCXMtPnZhbGlkID0gMTsKIAog
CQkJbGlzdGVuZXJzID0gJnBlcl9jcHUobGlzdGVuZXJfYXJyYXksIGNwdSk7CiAJCQlkb3duX3dy
aXRlKCZsaXN0ZW5lcnMtPnNlbSk7CiAJCQlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoczIsIHRt
cCwgJmxpc3RlbmVycy0+bGlzdCwgbGlzdCkgewotCQkJCWlmIChzMi0+cGlkID09IHBpZCkKKwkJ
CQlpZiAoczItPnBpZCA9PSBwaWQgJiYgczItPnBpZF9ucyA9PSBwaWRfbnMpCiAJCQkJCWdvdG8g
bmV4dF9jcHU7CiAJCQl9CiAJCQlsaXN0X2FkZCgmcy0+bGlzdCwgJmxpc3RlbmVycy0+bGlzdCk7
CkBAIC0zMjQsNyArMzM2LDcgQEAgY2xlYW51cDoKIAkJbGlzdGVuZXJzID0gJnBlcl9jcHUobGlz
dGVuZXJfYXJyYXksIGNwdSk7CiAJCWRvd25fd3JpdGUoJmxpc3RlbmVycy0+c2VtKTsKIAkJbGlz
dF9mb3JfZWFjaF9lbnRyeV9zYWZlKHMsIHRtcCwgJmxpc3RlbmVycy0+bGlzdCwgbGlzdCkgewot
CQkJaWYgKHMtPnBpZCA9PSBwaWQpIHsKKwkJCWlmIChzLT5waWQgPT0gcGlkICYmIHMtPnBpZF9u
cyA9PSBwaWRfbnMpIHsKIAkJCQlsaXN0X2RlbCgmcy0+bGlzdCk7CiAJCQkJa2ZyZWUocyk7CiAJ
CQkJYnJlYWs7Cg==
--001517402310aa7fcc04a6f091d7--
