MIME-Version: 1.0
In-Reply-To: <CAGXu5jKY+Fc5PcZdbXEXKXsxN2xb9Ext15yrhPrg4Afd1Rq_yA@mail.gmail.com>
References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <85inkpie9o.fsf@boum.org> <1495724872.20270.46.camel@redhat.com>
 <8537bt9bvj.fsf@boum.org> <1495727974.20270.48.camel@redhat.com> <CAGXu5jKY+Fc5PcZdbXEXKXsxN2xb9Ext15yrhPrg4Afd1Rq_yA@mail.gmail.com>
From: HacKurx <hackurx@gmail.com>
Date: Fri, 26 May 2017 09:55:37 +0200
Message-ID: <CAFwXZv_Nb5Q8n1kobbxz7+3w4r6pt-fD5YR4jw6_ZeXk1__9+A@mail.gmail.com>
Content-Type: multipart/mixed; boundary="94eb2c1930b4c71b5e055068a97f"
Subject: Re: [kernel-hardening] Patch for random mac address
To: Kees Cook <keescook@chromium.org>
Cc: Rik van Riel <riel@redhat.com>, intrigeri <intrigeri@boum.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c1930b4c71b5e055068a97f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2017-05-25 19:28 GMT+02:00 Kees Cook <keescook@chromium.org>:
> On Thu, May 25, 2017 at 8:59 AM, Rik van Riel <riel@redhat.com> wrote:
>> On Thu, 2017-05-25 at 17:47 +0200, intrigeri wrote:
>>> Rik van Riel:
>>> > That suggests maybe this kind of functionality should
>>> > be implemented in userspace, instead?
>>> > Maybe in NetworkManager, [=E2=80=A6]
>>>
>>> It's already implemented in NetworkManager :)
>>
>> So this kernel patch does not solve any problem,
>> because the solution has already been implemented
>> in userspace?
>
> It makes sure you can never not randomize the MAC

You have perfectly understood.

> BTW, the proposed patch is slightly wrong: it still allows userspace
> to change the MAC address.

This is not the most important because it is already another MAC
address because this patch randomize MAC whenever interface is brought
up.

> The ifdef with the return 0 should be moved
> up (and "return 0" seems like a bit of a lie: maybe -EINVAL or
> -ENOTSUPPORTED?).
-EINVAL seems to be a good idea, I will use it to never reveal the
permanent MAC address.

> How about sending a v2 with that fixed, inline, etc.

Agree with the V2. I'm not a developer, what do you mean by inline? Send by=
 GIT?
If someone can make him grow in my place I will pay him a beer ^^

Thank you all. Best regards,

HacKurx (Loic)

--94eb2c1930b4c71b5e055068a97f
Content-Type: text/plain; charset="US-ASCII"; name="random-mac_linux-4.12-rc2_v2.diff"
Content-Disposition: attachment;
	filename="random-mac_linux-4.12-rc2_v2.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j35jv4iw0

ZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0L2NvcmUvZGV2LmMKaW5kZXggZmNhNDA3
Yi4uM2VlYjQyYiAxMDA2NDQKLS0tIGEvbmV0L2NvcmUvZGV2LmMKKysrIGIvbmV0L2NvcmUvZGV2
LmMKQEAgLTY2NjksNiArNjY2OSwyNiBAQCBpbnQgZGV2X2NoYW5nZV9mbGFncyhzdHJ1Y3QgbmV0
X2RldmljZSAqZGV2LCB1bnNpZ25lZCBpbnQgZmxhZ3MpCiAKIAljaGFuZ2VzID0gKG9sZF9mbGFn
cyBeIGRldi0+ZmxhZ3MpIHwgKG9sZF9nZmxhZ3MgXiBkZXYtPmdmbGFncyk7CiAJX19kZXZfbm90
aWZ5X2ZsYWdzKGRldiwgb2xkX2ZsYWdzLCBjaGFuZ2VzKTsKKworI2lmZGVmIENPTkZJR19SQU5E
T01fTUFDX0FERFJFU1MKKwlpZiAoKGNoYW5nZXMgJiBJRkZfVVApICYmICEob2xkX2ZsYWdzICYg
SUZGX1VQKSkgeworCQkvKiByYW5kb21pemUgTUFDIHdoZW5ldmVyIGludGVyZmFjZSBpcyBicm91
Z2h0IHVwICovCisJCXN0cnVjdCBzb2NrYWRkciBzYTsKKwkJdW5zaWduZWQgaW50IG1hYzQ7CisJ
CXVuc2lnbmVkIHNob3J0IG1hYzI7CisKKwkJbWFjNCA9IHByYW5kb21fdTMyKCk7CisJCW1hYzIg
PSBwcmFuZG9tX3UzMigpOworCQltZW1jcHkoc2Euc2FfZGF0YSwgJm1hYzQsIHNpemVvZihtYWM0
KSk7CisJCW1lbWNweSgoY2hhciAqKXNhLnNhX2RhdGEgKyBzaXplb2YobWFjNCksICZtYWMyLCBz
aXplb2YobWFjMikpOworCQlpZiAoIWlzX3ZhbGlkX2V0aGVyX2FkZHIoc2Euc2FfZGF0YSkpCisJ
CQlzYS5zYV9kYXRhWzVdID0gMTsKKwkJc2Euc2FfZGF0YVswXSAmPSAweEZDOworCQlzYS5zYV9m
YW1pbHkgPSBkZXYtPnR5cGU7CisJCWRldl9zZXRfbWFjX2FkZHJlc3MoZGV2LCAmc2EpOworCX0K
KyNlbmRpZgorCiAJcmV0dXJuIHJldDsKIH0KIEVYUE9SVF9TWU1CT0woZGV2X2NoYW5nZV9mbGFn
cyk7CmRpZmYgLS1naXQgYS9uZXQvY29yZS9kZXZfaW9jdGwuYyBiL25ldC9jb3JlL2Rldl9pb2N0
bC5jCmluZGV4IGI5NGIxZDIuLmIwMjBkMTUgMTAwNjQ0Ci0tLSBhL25ldC9jb3JlL2Rldl9pb2N0
bC5jCisrKyBiL25ldC9jb3JlL2Rldl9pb2N0bC5jCkBAIC00NjMsNyArNDYzLDEyIEBACiAJCQkJ
CSBzaXplb2Yoc3RydWN0IGlmcmVxKSkpCiAJCQkJcmV0ID0gLUVGQVVMVDsKIAkJfQorI2lmZGVm
IENPTkZJR19SQU5ET01fTUFDX0FERFJFU1MKKwkJLyogRG9uJ3QgcmV2ZWFsIHRoZSBwZXJtYW5l
bnQgTUFDIGFkZHJlc3MgKi8KKwkJcmV0dXJuIC1FSU5WQUw7CisjZWxzZQogCQlyZXR1cm4gcmV0
OworI2VuZGlmCiAKIAkvKgogCSAqCVRoZXNlIGlvY3RsIGNhbGxzOgpkaWZmIC0tZ2l0IGEvc2Vj
dXJpdHkvS2NvbmZpZyBiL3NlY3VyaXR5L0tjb25maWcKaW5kZXggOTMwMjdmZC4uNmI3YjZmYyAx
MDA2NDQKLS0tIGEvc2VjdXJpdHkvS2NvbmZpZworKysgYi9zZWN1cml0eS9LY29uZmlnCkBAIC02
Nyw2ICs2NywxNCBAQCBjb25maWcgU0VDVVJJVFlfTkVUV09SS19YRlJNCiAJICBJUFNlYy4KIAkg
IElmIHlvdSBhcmUgdW5zdXJlIGhvdyB0byBhbnN3ZXIgdGhpcyBxdWVzdGlvbiwgYW5zd2VyIE4u
CiAKK2NvbmZpZyBSQU5ET01fTUFDX0FERFJFU1MKKwlib29sICJVc2UgcmFuZG9tIE1BQyBhZHJl
c3NlcyIKKwlkZWZhdWx0IG4KKwloZWxwCisJICBTYXkgWSBoZXJlIGZvciByYW5kb21pemUgdGhl
IE1BQyBhZGRyZXNzZXMgb2YgbmV0d29yayBpbnRlcmZhY2VzLgorCSAgVGhpcyBvcHRpb24gaXMg
cmVjb21tZW5kZWQgZm9yIHBlb3BsZSB3aG8gd2FudCB0byBpbmNyZWFzZSB0aGVpciBwcml2YWN5
LgorCSAgSWYgeW91IGFyZSB1bnN1cmUgaG93IHRvIGFuc3dlciB0aGlzIHF1ZXN0aW9uLCBhbnN3
ZXIgTi4KKwogY29uZmlnIFNFQ1VSSVRZX1BBVEgKIAlib29sICJTZWN1cml0eSBob29rcyBmb3Ig
cGF0aG5hbWUgYmFzZWQgYWNjZXNzIGNvbnRyb2wiCiAJZGVwZW5kcyBvbiBTRUNVUklUWQo=
--94eb2c1930b4c71b5e055068a97f--
